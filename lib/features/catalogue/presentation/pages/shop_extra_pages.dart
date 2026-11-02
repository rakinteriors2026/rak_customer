import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/submit_product_enquiry.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/favourites_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/product_enquiry_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/catalogue_page.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/product_artwork.dart';
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
              onBack: () => _leaveShopPage(context),
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
            title: 'Search',
            subtitle: '${branch.name} · ${branch.area}',
            onBack: () => _leaveShopPage(context),
            child: Padding(
              padding: context.figPagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    autofocus: true,
                    style: AppText.body.fig(context),
                    decoration: InputDecoration(
                      hintText: 'Search furniture',
                      filled: false,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        size: context.s(16),
                        color: AppColors.muted,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: context.s(28),
                        minHeight: context.s(28),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: context.s(10),
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.line),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.line),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.ink),
                      ),
                    ),
                    onChanged: (value) => _query.value = value,
                  ),
                  SizedBox(height: context.s(8)),
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
                                  return const FigText(
                                    'No matches yet.',
                                    style: AppText.body,
                                    color: AppColors.muted,
                                  );
                                }
                                return ListView.separated(
                                  itemCount: products.length,
                                  separatorBuilder: (_, _) => const Divider(
                                    height: 1,
                                    color: AppColors.line,
                                  ),
                                  itemBuilder: (context, index) {
                                    return _SearchResult(
                                      product: products[index],
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

class _SearchResult extends StatelessWidget {
  const _SearchResult({required this.product});

  final CatalogueProduct product;

  @override
  Widget build(BuildContext context) {
    final asset = ProductArtwork.assetFor(product.imageHint);
    final thumb = context.s(56);
    return InkWell(
      onTap: () => context.push('/shop/products/${product.id}'),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(12)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.s(8)),
              child: ColoredBox(
                color: AppColors.sand,
                child: SizedBox(
                  width: thumb,
                  height: thumb,
                  child: Padding(
                    padding: EdgeInsets.all(context.s(6)),
                    child: Image.asset(
                      asset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.s(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(product.name, style: AppText.label),
                  SizedBox(height: context.s(2)),
                  FigText(
                    product.specs,
                    style: AppText.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: context.s(14),
              color: AppColors.muted,
            ),
          ],
        ),
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
      onBack: () => _leaveShopPage(context),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          Text('Sort', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Popular, price and newest are applied on the storefront.',
          ),
          const SizedBox(height: AppSpacing.lg),
          RakButton(
            label: 'Show results',
            onPressed: () => _leaveShopPage(context),
          ),
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
  final _furniture = TextEditingController();
  final _dimensions = TextEditingController();
  final _room = TextEditingController();
  final _contact = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _furniture.dispose();
    _dimensions.dispose();
    _room.dispose();
    _contact.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductEnquiryCubit, ProductEnquiryState>(
      listener: (context, state) {
        if (state is ProductEnquirySuccess) {
          context.go('/enquiry/sent', extra: state.enquiry);
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
                controller: _furniture,
                enabled: !ready.submitting,
                decoration: const InputDecoration(
                  hintText: 'Furniture or product',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _dimensions,
                enabled: !ready.submitting,
                decoration: const InputDecoration(
                  hintText: 'Dimensions, if known',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _room,
                enabled: !ready.submitting,
                decoration: const InputDecoration(
                  hintText: 'Room or project',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _contact,
                enabled: !ready.submitting,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Contact number, if we should call',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _notes,
                enabled: !ready.submitting,
                minLines: 4,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Requirements and comments',
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
                        EnquiryDraft(
                          furnitureType: _furniture.text,
                          dimensions: _dimensions.text,
                          room: _room.text,
                          contact: _contact.text,
                          notes: _notes.text,
                        ),
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
  const EnquirySentPage({super.key, this.enquiry});

  final ProductEnquiry? enquiry;

  @override
  Widget build(BuildContext context) {
    final reference = enquiry?.id;
    return RakPage(
      title: 'Enquiry sent',
      subtitle: reference == null
          ? 'A consultant will be in touch.'
          : 'Reference $reference',
      child: ListView(
        padding: context.figPagePadding,
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 48),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            reference == null
                ? 'This is not an order. We will use the details you shared to prepare a quotation.'
                : 'Reference $reference is submitted. This is not an order, and nothing was added to your cart.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          if (reference != null) ...[
            RakButton(
              label: 'View enquiry',
              onPressed: () => context.go('/enquiries/$reference'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          RakButton(
            label: 'Back to shop',
            style: reference == null
                ? RakButtonStyle.primary
                : RakButtonStyle.secondary,
            onPressed: () => context.go('/shop'),
          ),
        ],
      ),
    );
  }
}

void _leaveShopPage(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/shop');
  }
}
