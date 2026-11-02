import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/update_support_status.dart';
import 'package:rak_customer/features/support/presentation/cubit/support_detail_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

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
        updateSupportStatus: sl<UpdateSupportStatus>(),
        accountId: accountId,
        queryId: queryId,
      )..load(),
      child: BlocBuilder<SupportDetailCubit, SupportDetailState>(
        builder: (context, state) {
          return switch (state) {
            SupportDetailLoading() => const RakPage(
              title: 'Your question',
              subtitle: 'With Priya',
              child: AppLoading(),
            ),
            SupportDetailError(:final message) => RakPage(
              title: 'Your question',
              subtitle: 'With Priya',
              onBack: () => context.go('/support'),
              child: AppErrorState(
                message: message,
                onRetry: () => context.read<SupportDetailCubit>().load(),
              ),
            ),
            SupportDetailLoaded(:final query) => _QuestionThread(query: query),
          };
        },
      ),
    );
  }
}

class _QuestionThread extends StatelessWidget {
  const _QuestionThread({required this.query});

  final SupportQuery query;

  @override
  Widget build(BuildContext context) {
    final reply = query.consultantReply;
    final closed = query.status == 'closed';
    return RakPage(
      title: query.subject,
      subtitle:
          '${query.statusLabel} · ${DateFormatter.displayShort(query.createdAt)}',
      onBack: () => context.go('/support'),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const FigText('Priya', style: AppText.screenTitle),
          SizedBox(height: context.s(2)),
          const FigText(
            'Your consultant · Project support',
            style: AppText.caption,
          ),
          SizedBox(height: context.s(20)),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(20)),
          const FigText('You', style: AppText.caption),
          SizedBox(height: context.s(6)),
          FigText(query.message, style: AppText.body),
          SizedBox(height: context.s(20)),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(20)),
          const FigText('Priya', style: AppText.caption),
          SizedBox(height: context.s(6)),
          FigText(
            reply ?? 'Priya will reply in this thread.',
            style: AppText.body,
            color: reply == null ? AppColors.muted : AppColors.ink,
          ),
          SizedBox(height: context.s(20)),
          FigText('Reference ${query.id}', style: AppText.caption),
          if (closed) ...[
            SizedBox(height: context.s(6)),
            const FigText(
              'This question is closed.',
              style: AppText.caption,
            ),
          ],
          SizedBox(height: context.s(28)),
          RakButton(
            label: 'Ask another question',
            onPressed: () => context.go('/support'),
          ),
          SizedBox(height: context.s(8)),
          RakButton(
            label: 'Back to projects',
            style: RakButtonStyle.plain,
            onPressed: () => context.go('/projects'),
          ),
          if (query.status == 'open')
            RakButton(
              label: 'Show a sample reply',
              style: RakButtonStyle.plain,
              onPressed: () =>
                  context.read<SupportDetailCubit>().mark('replied'),
            ),
          if (query.status == 'replied')
            RakButton(
              label: 'Close question',
              style: RakButtonStyle.plain,
              onPressed: () =>
                  context.read<SupportDetailCubit>().mark('closed'),
            ),
        ],
      ),
    );
  }
}
