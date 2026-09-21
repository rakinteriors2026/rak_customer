import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_query.dart';
import 'package:rak_customer/features/support/presentation/cubit/support_detail_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class SupportDetailPage extends StatelessWidget {
  const SupportDetailPage({
    super.key,
    required this.accountId,
    required this.queryId,
  });

  final String accountId;
  final String queryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportDetailCubit(
        getSupportQuery: sl<GetSupportQuery>(),
        accountId: accountId,
        queryId: queryId,
      )..load(),
      child: BlocBuilder<SupportDetailCubit, SupportDetailState>(
        builder: (context, state) {
          return switch (state) {
            SupportDetailLoading() => const RakPage(
              title: 'Question sent',
              subtitle: 'We’ve passed it to your consultant.',
              child: AppLoading(),
            ),
            SupportDetailError(:final message) => RakPage(
              title: 'Question sent',
              subtitle: 'We’ve passed it to your consultant.',
              onBack: () => context.go('/support'),
              child: AppErrorState(
                message: message,
                onRetry: () => context.read<SupportDetailCubit>().load(),
              ),
            ),
            SupportDetailLoaded(:final query) => RakPage(
              title: 'Question sent',
              subtitle: 'We’ve passed it to your consultant.',
              onBack: () => context.go('/support'),
              child: ListView(
                padding: context.figPagePadding,
                children: [
                  RakStatusBanner(text: 'Query ${query.id} · ${query.status}'),
                  const SizedBox(height: AppSpacing.md),
                  RakInfoCard(title: query.subject, detail: query.message),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Your consultant will review your question. You can refer to ${query.id} when following up.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Opened ${DateFormatter.displayDate(query.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  RakButton(
                    label: 'Back to projects',
                    onPressed: () => context.go('/projects'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RakButton(
                    label: 'Ask another question',
                    style: RakButtonStyle.secondary,
                    onPressed: () => context.go('/support'),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
