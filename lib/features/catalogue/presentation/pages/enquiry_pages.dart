import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/list_product_enquiries.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/update_enquiry_status.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/enquiry_detail_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/enquiry_list_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class EnquiryListPage extends StatelessWidget {
  const EnquiryListPage({super.key, this.accountId});

  final String? accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnquiryListCubit(
        listProductEnquiries: sl<ListProductEnquiries>(),
        accountId: accountId,
      )..load(),
      child: const _EnquiryListView(),
    );
  }
}

class _EnquiryListView extends StatelessWidget {
  const _EnquiryListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnquiryListCubit, EnquiryListState>(
      builder: (context, state) {
        return RakPage(
          title: 'Quote enquiries',
          subtitle: 'Separate from your cart and orders.',
          onBack: () => context.pop(),
          child: switch (state) {
            EnquiryListLoading() => const AppLoading(),
            EnquiryListEmpty() => AppEmptyState(
              title: 'No enquiries yet',
              message:
                  'Quote-only and custom furniture requests appear here after you send them.',
              actionLabel: 'Request a quote',
              onAction: () => context.push('/enquiry'),
              icon: Icons.forum_outlined,
            ),
            EnquiryListError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<EnquiryListCubit>().load(),
            ),
            EnquiryListLoaded(:final enquiries) => ListView(
              padding: context.figPagePadding,
              children: [
                for (final enquiry in enquiries) ...[
                  RakInfoCard(
                    title: enquiry.statusLabel,
                    detail: '${enquiry.id}\n${enquiry.summary}',
                    onTap: () => context.push('/enquiries/${enquiry.id}'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          },
        );
      },
    );
  }
}

class EnquiryDetailPage extends StatelessWidget {
  const EnquiryDetailPage({super.key, required this.enquiryId});

  final String enquiryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnquiryDetailCubit(
        getProductEnquiry: sl<GetProductEnquiry>(),
        updateEnquiryStatus: sl<UpdateEnquiryStatus>(),
        enquiryId: enquiryId,
      )..load(),
      child: const _EnquiryDetailView(),
    );
  }
}

class _EnquiryDetailView extends StatelessWidget {
  const _EnquiryDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnquiryDetailCubit, EnquiryDetailState>(
      builder: (context, state) {
        final enquiry = state is EnquiryDetailLoaded ? state.enquiry : null;
        return RakPage(
          title: 'Enquiry',
          subtitle: enquiry == null
              ? 'Quote request'
              : 'Reference ${enquiry.id}',
          onBack: () => context.pop(),
          child: switch (state) {
            EnquiryDetailLoading() => const AppLoading(),
            EnquiryDetailError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<EnquiryDetailCubit>().load(),
            ),
            EnquiryDetailLoaded(:final enquiry) => ListView(
              padding: context.figPagePadding,
              children: [
                RakStatusBanner(text: enquiry.statusLabel),
                const SizedBox(height: AppSpacing.md),
                RakInfoCard(
                  title: 'Submitted details',
                  detail: enquiry.message,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Sent ${DateFormatter.displayDate(enquiry.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                if (enquiry.consultantNote != null) ...[
                  RakInfoCard(
                    title: 'Consultant',
                    detail: enquiry.consultantNote!,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Text(
                  'This enquiry does not create a cart item or an order.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: AppSpacing.md),
                for (final status in enquiry.demoNextStatuses) ...[
                  RakButton(
                    label: _statusAction(status),
                    style: status == enquiry.demoNextStatuses.first
                        ? RakButtonStyle.primary
                        : RakButtonStyle.secondary,
                    onPressed: () =>
                        context.read<EnquiryDetailCubit>().advance(status),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                RakButton(
                  label: 'Back to shop',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.go('/shop'),
                ),
              ],
            ),
          },
        );
      },
    );
  }

  String _statusAction(String status) {
    return switch (status) {
      'contacted' => 'Mark consultant contacted',
      'quote_prepared' => 'Mark quote prepared',
      'accepted' => 'Accept quote',
      'declined' => 'Decline quote',
      'closed' => 'Close enquiry',
      _ => status,
    };
  }
}
