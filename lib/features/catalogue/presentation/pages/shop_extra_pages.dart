import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/submit_product_enquiry.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/favourites_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/product_enquiry_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/catalogue_page.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBranchCubit, ShopBranch>(
      bloc: sl<ShopBranchCubit>(),
      builder: (context, branch) {
        return BlocBuilder<FavouritesCubit, Set<String>>(
          builder: (context, ids) {
            return RakPage(
              title: 'Your favourites',
              subtitle: ids.isEmpty
                  ? 'Your next favourite is waiting.'
                  : branch.label,
              onBack: () => context.pop(),
              child: BlocProvider(
                create: (_) => sl<CatalogueCubit>()..load(),
                child: ids.isEmpty
                    ? AppEmptyState(
                        title: 'Nothing saved yet',
                        message:
                            'Browse the collection and keep your favourite pieces here for later.',
                        actionLabel: 'Explore the shop',
                        onAction: () => context.go('/shop'),
                        icon: Icons.favorite_border,
                      )
                    : BlocBuilder<CatalogueCubit, CatalogueState>(
                        buildWhen: (previous, current) =>
                            previous.runtimeType != current.runtimeType,
                        builder: (context, state) {
                          return switch (state) {
                            CatalogueLoading() => const AppLoading(),
                            CatalogueEmpty() => AppEmptyState(
                              title: 'Nothing to show',
                              message:
                                  'Saved pieces are no longer in the catalogue.',
                              actionLabel: 'Explore the shop',
                              onAction: () => context.go('/shop'),
                              icon: Icons.favorite_border,
                            ),
                            CatalogueError(:final message) => AppErrorState(
                              message: message,
                              onRetry: () =>
                                  context.read<CatalogueCubit>().load(),
                            ),
                            CatalogueLoaded(:final allProducts) =>
                              _FavouriteGrid(
                                products: allProducts
                                    .where(
                                      (product) => ids.contains(product.id),
                                    )
                                    .toList(),
                              ),
                          };
                        },
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _query = ValueNotifier('');

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogueCubit>()..load(),
      child: BlocBuilder<ShopBranchCubit, ShopBranch>(
        bloc: sl<ShopBranchCubit>(),
        builder: (context, branch) {
          return RakPage(
            title: 'Find your perfect piece',
            subtitle: 'Branch: ${branch.label}',
            onBack: () => context.pop(),
            child: Padding(
              padding: context.figPagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search furniture & home accents',
                    ),
                    onChanged: (value) => _query.value = value,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: BlocBuilder<CatalogueCubit, CatalogueState>(
                      buildWhen: (previous, current) =>
                          previous.runtimeType != current.runtimeType,
                      builder: (context, state) {
                        return switch (state) {
                          CatalogueLoading() => const AppLoading(),
                          CatalogueEmpty() => const AppEmptyState(
                            title: 'No products found',
                            message:
                                'The catalogue is empty right now. Please try again later.',
                            icon: Icons.search_off,
                          ),
                          CatalogueError(:final message) => AppErrorState(
                            message: message,
                            onRetry: () =>
                                context.read<CatalogueCubit>().load(),
                          ),
                          CatalogueLoaded(:final allProducts) =>
                            ValueListenableBuilder<String>(
                              valueListenable: _query,
                              builder: (context, query, _) {
                                final needle = query.trim().toLowerCase();
                                final products = needle.isEmpty
                                    ? allProducts
                                    : allProducts
                                          .where(
                                            (product) => product.name
                                                .toLowerCase()
                                                .contains(needle),
                                          )
                                          .toList();
                                if (products.isEmpty) {
                                  return Text(
                                    'No matches yet.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.muted),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(product.name),
                                      subtitle: Text(product.specs),
                                      onTap: () => context.push(
                                        '/shop/products/${product.id}',
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        };
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FiltersPage extends StatelessWidget {
  const FiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Filter & sort',
      subtitle: 'Refine your product selection.',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          Text('Sort', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Popular, price and newest are applied on the storefront.',
          ),
          const SizedBox(height: AppSpacing.lg),
          RakButton(label: 'Show results', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}

class _FavouriteGrid extends StatelessWidget {
  const _FavouriteGrid({required this.products});

  final List<CatalogueProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return AppEmptyState(
        title: 'Nothing saved is available',
        message:
            'Those pieces are no longer in the catalogue. Browse the shop to find something new.',
        actionLabel: 'Explore the shop',
        onAction: () => context.go('/shop'),
        icon: Icons.favorite_border,
      );
    }
    return GridView.builder(
      padding: context.figPagePadding,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.productCrossAxisCount,
        mainAxisSpacing: context.s(AppLayout.productGap),
        crossAxisSpacing: context.s(AppLayout.productGap),
        mainAxisExtent: context.productCardExtent,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          key: ValueKey(product.id),
          product: product,
          onTap: () => context.push('/shop/products/${product.id}'),
        );
      },
    );
  }
}

class ProductEnquiryPage extends StatelessWidget {
  const ProductEnquiryPage({super.key, this.productId, this.accountId});

  final String? productId;
  final String? accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductEnquiryCubit(
        submitProductEnquiry: sl<SubmitProductEnquiry>(),
        productId: productId,
        accountId: accountId,
      ),
      child: const _ProductEnquiryView(),
    );
  }
}

class _ProductEnquiryView extends StatefulWidget {
  const _ProductEnquiryView();

  @override
  State<_ProductEnquiryView> createState() => _ProductEnquiryViewState();
}

class _ProductEnquiryViewState extends State<_ProductEnquiryView> {
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductEnquiryCubit, ProductEnquiryState>(
      listener: (context, state) {
        if (state is ProductEnquirySuccess) {
          context.go('/enquiry/sent');
        }
      },
      builder: (context, state) {
        final ready = state is ProductEnquiryReady
            ? state
            : const ProductEnquiryReady();
        return RakPage(
          title: 'Request a quote',
          subtitle: 'A consultant will follow up. This is not a checkout.',
          onBack: () => context.pop(),
          child: ListView(
            padding: context.figPagePadding,
            children: [
              TextField(
                controller: _message,
                enabled: !ready.submitting,
                minLines: 4,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Tell us about the piece and your space',
                ),
              ),
              if (ready.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  ready.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              RakButton(
                label: ready.submitting ? 'Sending…' : 'Send enquiry',
                loading: ready.submitting,
                onPressed: ready.submitting
                    ? null
                    : () => context.read<ProductEnquiryCubit>().submit(
                        _message.text,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EnquirySentPage extends StatelessWidget {
  const EnquirySentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Enquiry sent',
      subtitle: 'A consultant will be in touch.',
      child: ListView(
        padding: context.figPagePadding,
        children: [
          Text(
            'This is not an order. We will use the details you shared to prepare a quotation.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Back to shop',
            onPressed: () => context.go('/shop'),
          ),
        ],
      ),
    );
  }
}
