import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/list_shop_branches.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class ChooseBranchPage extends StatelessWidget {
  const ChooseBranchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<ListShopBranches>()(),
      builder: (context, snapshot) {
        final branches = snapshot.data?.valueOrNull ?? ShopBranch.all;
        return BlocBuilder<ShopBranchCubit, ShopBranch>(
          bloc: sl<ShopBranchCubit>(),
          builder: (context, selected) {
            return RakPage(
              title: 'Choose your branch',
              subtitle: 'Browse products available near you.',
              onBack: () => context.pop(),
              child: ListView(
                padding: context.figPagePadding,
                children: [
                  RakStatusBanner(text: selected.label),
                  const SizedBox(height: AppSpacing.sm),
                  FigText(
                    'Select the location closest to you. Availability may vary by branch.',
                    style: AppText.body,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final branch in branches) ...[
                    RakInfoCard(
                      title: branch.name,
                      detail: branch.area,
                      onTap: () async {
                        await sl<ShopBranchCubit>().select(branch.id);
                        if (context.mounted) context.pop();
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class BranchUnavailablePage extends StatelessWidget {
  const BranchUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBranchCubit, ShopBranch>(
      bloc: sl<ShopBranchCubit>(),
      builder: (context, branch) {
        return RakPage(
          title: 'Unavailable here',
          subtitle: 'This item is not available at this branch.',
          onBack: () => context.pop(),
          child: ListView(
            padding: context.figPagePadding,
            children: [
              RakStatusBanner(text: branch.label),
              const SizedBox(height: AppSpacing.sm),
              FigText(
                'Choose another branch or browse products available at your selected location.',
                style: AppText.body,
                color: AppColors.muted,
              ),
              const SizedBox(height: AppSpacing.sm),
              RakButton(
                label: 'Choose another branch',
                onPressed: () => context.push('/shop/branch'),
              ),
              const SizedBox(height: AppSpacing.sm),
              RakButton(
                label: 'Browse available products',
                style: RakButtonStyle.secondary,
                onPressed: () => context.go('/shop'),
              ),
              const SizedBox(height: AppSpacing.sm),
              RakButton(
                label: 'Contact customer support',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/account/customer-support'),
              ),
            ],
          ),
        );
      },
    );
  }
}
