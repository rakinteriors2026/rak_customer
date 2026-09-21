import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/app/shell.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/auth/presentation/pages/account_extra_pages.dart';
import 'package:rak_customer/features/auth/presentation/pages/account_page.dart';
import 'package:rak_customer/features/auth/presentation/pages/otp_entry_page.dart';
import 'package:rak_customer/features/auth/presentation/pages/phone_entry_page.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/add_cart_item.dart';
import 'package:rak_customer/features/cart/presentation/pages/cart_page.dart';
import 'package:rak_customer/features/cart/presentation/pages/checkout_pages.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/catalogue_page.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/product_360_page.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/product_detail_page.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/shop_branch_pages.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/shop_extra_pages.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/visualise_pages.dart';
import 'package:rak_customer/features/designs/presentation/widgets/project_designs_section.dart';
import 'package:rak_customer/features/documents/presentation/widgets/project_documents_section.dart';
import 'package:rak_customer/features/finance/presentation/widgets/project_finance_section.dart';
import 'package:rak_customer/features/home/presentation/pages/home_page.dart';
import 'package:rak_customer/features/home/presentation/pages/sales_kit_pages.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/presentation/pages/access_denied_page.dart';
import 'package:rak_customer/features/notifications/presentation/pages/notifications_page.dart';
import 'package:rak_customer/features/projects/presentation/pages/project_list_page.dart';
import 'package:rak_customer/features/projects/presentation/pages/project_section_page.dart';
import 'package:rak_customer/features/projects/presentation/pages/project_timeline_page.dart';
import 'package:rak_customer/features/projects/presentation/pages/review_pages.dart';
import 'package:rak_customer/features/support/presentation/pages/create_query_page.dart';
import 'package:rak_customer/features/support/presentation/pages/support_detail_page.dart';
import 'package:rak_customer/features/support/presentation/pages/support_list_page.dart';
import 'package:rak_customer/features/updates/presentation/widgets/project_updates_section.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

String? _accountId(SessionCubit sessionCubit) {
  final session = sessionCubit.state;
  if (session is SessionAuthenticated) return session.account.id;
  return null;
}

String _displayName(SessionCubit sessionCubit) {
  final session = sessionCubit.state;
  if (session is SessionAuthenticated) return session.account.displayName;
  return 'there';
}

Widget _productDetailPage(GoRouterState state, SessionCubit sessionCubit) {
  final id = state.pathParameters['id']!;
  return ProductDetailPage(
    productId: id,
    onAddToCart: (product) async {
      final available = await sl<ShopBranchRepository>().isProductAvailable(
        productId: product.id,
      );
      if (available.valueOrNull == false) {
        return 'This item is not available at this branch.';
      }
      final result = await sl<AddCartItem>()(
        productId: product.id,
        accountId: _accountId(sessionCubit),
      );
      return result.fold(
        onSuccess: (_) => 'Added to cart',
        onFailure: (failure) => failure.message,
      );
    },
    onRequestQuote: (product) async {
      return 'A consultant will follow up about ${product.name}.';
    },
  );
}

GoRouter createRouter(SessionCubit sessionCubit) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(sessionCubit.stream),
    redirect: (context, state) {
      final session = sessionCubit.state;
      if (session is SessionUnknown) return null;
      final location = state.matchedLocation;
      final loggingIn = location.startsWith('/login');
      final needsAuth =
          location.startsWith('/projects') ||
          location.startsWith('/notifications') ||
          location.startsWith('/checkout') ||
          location.startsWith('/orders') ||
          location == '/address' ||
          location == '/access-denied' ||
          location.startsWith('/account/delete') ||
          location.startsWith('/support/');
      final signedIn = session is SessionAuthenticated;
      if (!signedIn && needsAuth) return '/login';
      if (signedIn && loggingIn) return '/home';
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => HomePage(
                  displayName: _displayName(sessionCubit),
                  accountId: _accountId(sessionCubit),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return ProjectListPage(accountId: accountId);
                },
              ),
              GoRoute(
                path: '/projects/:id/timeline',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return ProjectTimelinePage(
                    accountId: accountId,
                    projectId: state.pathParameters['id']!,
                  );
                },
              ),
              GoRoute(
                path: '/projects/:id/updates',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  final projectId = state.pathParameters['id']!;
                  return ProjectSectionPage(
                    title: 'From your site',
                    subtitle: 'Latest published updates',
                    child: ProjectUpdatesSection(
                      accountId: accountId,
                      projectId: projectId,
                      showHeading: false,
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/projects/:id/payments',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  final projectId = state.pathParameters['id']!;
                  return ProjectSectionPage(
                    title: 'Project payments',
                    subtitle: 'Figures published by RAK finance',
                    child: ProjectFinanceSection(
                      accountId: accountId,
                      projectId: projectId,
                      showHeading: false,
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/projects/:id/documents',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  final projectId = state.pathParameters['id']!;
                  return ProjectSectionPage(
                    title: 'Your documents',
                    subtitle: 'Quotations, agreements and invoices',
                    child: ProjectDocumentsSection(
                      accountId: accountId,
                      projectId: projectId,
                      showHeading: false,
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/projects/:id/designs',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  final projectId = state.pathParameters['id']!;
                  return ProjectSectionPage(
                    title: 'Approved designs',
                    subtitle: 'A clear picture of what is coming.',
                    child: ProjectDesignsSection(
                      accountId: accountId,
                      projectId: projectId,
                      showHeading: false,
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/projects/:id/review',
                builder: (context, state) {
                  final projectId = state.pathParameters['id']!;
                  return ReviewCentrePage(
                    projectId: projectId,
                    projectName: state.extra is String
                        ? state.extra as String
                        : 'Palm Grove Residence',
                  );
                },
              ),
              GoRoute(
                path: '/projects/:id/review/quotation',
                builder: (context, state) =>
                    QuotationReviewPage(projectId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: '/projects/:id/review/quotation/approve',
                builder: (context, state) => ConfirmApprovalPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'quotation',
                ),
              ),
              GoRoute(
                path: '/projects/:id/review/quotation/reject',
                builder: (context, state) => RejectDecisionPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'quotation',
                ),
              ),
              GoRoute(
                path: '/projects/:id/review/quotation/approved',
                builder: (context, state) => DecisionResultPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'quotation',
                  approved: true,
                ),
              ),
              GoRoute(
                path: '/projects/:id/review/quotation/rejected',
                builder: (context, state) => DecisionResultPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'quotation',
                  approved: false,
                ),
              ),
              GoRoute(
                path: '/projects/:id/review/design',
                builder: (context, state) =>
                    DesignReviewPage(projectId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: '/projects/:id/review/design/full',
                builder: (context, state) =>
                    DesignFullViewPage(projectId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: '/projects/:id/review/design/approve',
                builder: (context, state) => ConfirmApprovalPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'design',
                ),
              ),
              GoRoute(
                path: '/projects/:id/review/design/reject',
                builder: (context, state) => RejectDecisionPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'design',
                ),
              ),
              GoRoute(
                path: '/projects/:id/review/design/approved',
                builder: (context, state) => DecisionResultPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'design',
                  approved: true,
                ),
              ),
              GoRoute(
                path: '/projects/:id/review/design/rejected',
                builder: (context, state) => DecisionResultPage(
                  projectId: state.pathParameters['id']!,
                  kind: 'design',
                  approved: false,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shop',
                builder: (context, state) => const CataloguePage(),
                routes: [
                  GoRoute(
                    path: 'products/:id',
                    builder: (context, state) =>
                        _productDetailPage(state, sessionCubit),
                    routes: [
                      GoRoute(
                        path: '360',
                        builder: (context, state) => Product360Page(
                          productId: state.pathParameters['id']!,
                          productName: state.extra is String
                              ? state.extra as String
                              : 'Linen lounge chair · Natural oak',
                        ),
                      ),
                      GoRoute(
                        path: 'visualise',
                        builder: (context, state) => VisualiseHubPage(
                          productId: state.pathParameters['id']!,
                          productName: state.extra is String
                              ? state.extra as String
                              : 'Linen lounge chair',
                        ),
                        routes: [
                          GoRoute(
                            path: 'ai/:step',
                            builder: (context, state) => VisualiseAiPage(
                              productId: state.pathParameters['id']!,
                              productName: state.extra is String
                                  ? state.extra as String
                                  : 'Linen lounge chair',
                              step: state.pathParameters['step']!,
                            ),
                          ),
                          GoRoute(
                            path: 'ar/:step',
                            builder: (context, state) => VisualiseArPage(
                              productId: state.pathParameters['id']!,
                              productName: state.extra is String
                                  ? state.extra as String
                                  : 'Linen lounge chair',
                              step: state.pathParameters['step']!,
                            ),
                          ),
                          GoRoute(
                            path: 'saved',
                            builder: (context, state) => VisualiseSavedPage(
                              productId: state.pathParameters['id']!,
                              productName: state.extra is String
                                  ? state.extra as String
                                  : 'Linen lounge chair',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'branch',
                    builder: (context, state) => const ChooseBranchPage(),
                  ),
                  GoRoute(
                    path: 'unavailable',
                    builder: (context, state) => const BranchUnavailablePage(),
                  ),
                ],
              ),
              GoRoute(
                path: '/products/:id',
                builder: (context, state) =>
                    _productDetailPage(state, sessionCubit),
              ),
              GoRoute(
                path: '/cart',
                builder: (context, state) =>
                    CartPage(accountId: _accountId(sessionCubit)),
              ),
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchPage(),
              ),
              GoRoute(
                path: '/filters',
                builder: (context, state) => const FiltersPage(),
              ),
              GoRoute(
                path: '/favourites',
                builder: (context, state) => const FavouritesPage(),
              ),
              GoRoute(
                path: '/enquiry',
                builder: (context, state) => ProductEnquiryPage(
                  productId: state.uri.queryParameters['productId'],
                  accountId: _accountId(sessionCubit),
                ),
              ),
              GoRoute(
                path: '/enquiry/sent',
                builder: (context, state) => const EnquirySentPage(),
              ),
              GoRoute(
                path: '/checkout',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return CheckoutPage(accountId: accountId);
                },
              ),
              GoRoute(
                path: '/checkout/pay',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return PaymentProviderPage(accountId: accountId);
                },
              ),
              GoRoute(
                path: '/checkout/pending',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return PaymentPendingPage(accountId: accountId);
                },
              ),
              GoRoute(
                path: '/checkout/confirmed',
                builder: (context, state) {
                  final order = state.extra;
                  if (order is! ShopOrder) return const MissingOrderPage();
                  return OrderConfirmedPage(
                    order: order,
                    displayName: _displayName(sessionCubit),
                  );
                },
              ),
              GoRoute(
                path: '/checkout/failed',
                builder: (context, state) {
                  final extra = state.extra;
                  if (extra is PaymentFailedArgs) {
                    return PaymentFailedPage(
                      message: extra.message,
                      amountLabel: extra.amountLabel,
                    );
                  }
                  return PaymentFailedPage(
                    message: extra is String ? extra : null,
                  );
                },
              ),
              GoRoute(
                path: '/address',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return AddressPage(accountId: accountId);
                },
              ),
              GoRoute(
                path: '/orders',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return OrdersListPage(accountId: accountId);
                },
              ),
              GoRoute(
                path: '/orders/:id',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return OrderTrackingPage(
                    accountId: accountId,
                    orderId: state.pathParameters['id']!,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'help',
                    builder: (context, state) =>
                        OrderHelpPage(orderId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: 'cancellation',
                    builder: (context, state) => CancellationRequestedPage(
                      orderId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/support',
                builder: (context, state) {
                  final subject = state.uri.queryParameters['subject'];
                  final message = state.uri.queryParameters['message'];
                  return SupportListPage(
                    key: ValueKey('$subject|$message'),
                    accountId: _accountId(sessionCubit),
                    initialSubject: subject,
                    initialMessage: message,
                  );
                },
              ),
              GoRoute(
                path: '/support/new',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return CreateQueryPage(
                    accountId: accountId,
                    prefilledProjectId: state.uri.queryParameters['projectId'],
                    prefilledOrderId: state.uri.queryParameters['orderId'],
                  );
                },
              ),
              GoRoute(
                path: '/support/:id',
                builder: (context, state) {
                  final accountId = _accountId(sessionCubit);
                  if (accountId == null) return const SizedBox.shrink();
                  return SupportDetailPage(
                    accountId: accountId,
                    queryId: state.pathParameters['id']!,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountPage(),
                routes: [
                  GoRoute(
                    path: 'terms',
                    builder: (context, state) => const TermsConditionsPage(),
                    routes: [
                      GoRoute(
                        path: 'published',
                        builder: (context, state) => const PublishedTermsPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutUsPage(),
                  ),
                  GoRoute(
                    path: 'customer-support',
                    builder: (context, state) => const CustomerSupportPage(),
                  ),
                  GoRoute(
                    path: 'delete',
                    builder: (context, state) => const DeleteAccountPage(),
                    routes: [
                      GoRoute(
                        path: 'confirm',
                        builder: (context, state) {
                          final session = sessionCubit.state;
                          if (session is! SessionAuthenticated) {
                            return const SizedBox.shrink();
                          }
                          return ConfirmAccountDeletionPage(
                            phone: session.account.phone,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) {
          final accountId = _accountId(sessionCubit);
          if (accountId == null) return const SizedBox.shrink();
          final identity = sl<DeviceIdentity>();
          return NotificationsPage(
            accountId: accountId,
            pushPermissionGranted: identity.pushPermissionGranted,
          );
        },
      ),
      GoRoute(
        path: '/access-denied',
        builder: (context, state) => const AccessDeniedPage(),
      ),
      GoRoute(
        path: '/sales-kit',
        builder: (context, state) => const SalesKitPage(),
        routes: [
          GoRoute(
            path: 'story',
            builder: (context, state) => const ProjectStoryPage(),
          ),
          GoRoute(
            path: 'materials',
            builder: (context, state) => const MaterialDetailsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PhoneEntryPage(),
      ),
      GoRoute(
        path: '/login/otp',
        builder: (context, state) {
          final challenge = state.extra;
          if (challenge is! OtpChallenge) {
            return const PhoneEntryPage();
          }
          return OtpEntryPage(challenge: challenge);
        },
      ),
    ],
  );
}
