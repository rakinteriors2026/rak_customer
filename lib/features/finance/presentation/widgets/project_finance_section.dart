import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';
import 'package:rak_customer/features/finance/domain/usecases/get_project_finance.dart';
import 'package:rak_customer/features/finance/presentation/cubit/finance_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';

class ProjectFinanceSection extends StatelessWidget {
  const ProjectFinanceSection({
    super.key,
    required this.accountId,
    required this.projectId,
    this.showHeading = true,
  });

  final String accountId;
  final String projectId;
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinanceCubit(
        getProjectFinance: sl<GetProjectFinance>(),
        clock: sl<Clock>(),
        accountId: accountId,
        projectId: projectId,
      )..load(),
      child: _FinanceBody(showHeading: showHeading),
    );
  }
}

class _FinanceBody extends StatelessWidget {
  const _FinanceBody({required this.showHeading});
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeading) ...[
              Text('Payments', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
            ],
            switch (state) {
              FinanceLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              FinanceEmpty() => const AppEmptyState(
                title: 'Balance not yet available',
                message:
                    'Published payment figures from finance will appear here.',
                icon: Icons.account_balance_wallet_outlined,
              ),
              FinanceError(:final message) => AppErrorState(
                message: message,
                onRetry: () => context.read<FinanceCubit>().load(),
              ),
              FinanceLoaded(:final finance, :final stale) => FinanceLedgerView(
                finance: finance,
                stale: stale,
              ),
            },
          ],
        );
      },
    );
  }
}

class FinanceLedgerView extends StatelessWidget {
  const FinanceLedgerView({
    super.key,
    required this.finance,
    required this.stale,
  });

  final ProjectFinance finance;
  final bool stale;

  @override
  Widget build(BuildContext context) {
    final asOf = DateFormatter.displayDate(finance.asOf);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FigText('Due now', style: AppText.caption),
        SizedBox(height: context.s(4)),
        FigText(
          MoneyFormatter.format(finance.amountCurrentlyDue),
          style: AppText.display,
        ),
        SizedBox(height: context.s(18)),
        _MoneyLine(
          label: 'Outstanding total',
          value: MoneyFormatter.format(finance.outstandingTotal),
          emphasis: true,
        ),
        const Divider(height: 1, color: AppColors.line),
        _MoneyLine(
          label: 'Total contract value',
          value: MoneyFormatter.format(finance.totalContract),
        ),
        const Divider(height: 1, color: AppColors.line),
        _MoneyLine(
          label: 'Approved variations',
          value: MoneyFormatter.format(finance.approvedVariations),
        ),
        const Divider(height: 1, color: AppColors.line),
        _MoneyLine(
          label: 'Net received',
          value: MoneyFormatter.format(finance.netReceived),
        ),
        if (finance.hasCredit) ...[
          const Divider(height: 1, color: AppColors.line),
          _MoneyLine(
            label: 'Credit / overpayment',
            value: MoneyFormatter.format(finance.creditOverpayment),
          ),
        ],
        SizedBox(height: context.s(14)),
        FigText(
          stale
              ? 'Figures as of $asOf — may be out of date'
              : 'Figures as of $asOf',
          style: AppText.caption,
          color: stale ? AppColors.warning : null,
        ),
        SizedBox(height: context.s(4)),
        const FigText(
          'Payments made outside the app appear here after finance publishes them.',
          style: AppText.caption,
        ),
        if (finance.entries.isNotEmpty) ...[
          SizedBox(height: context.s(28)),
          const FigText('Ledger', style: AppText.screenTitle),
          SizedBox(height: context.s(4)),
          for (final entry in finance.entries) ...[
            _MoneyLine(
              label: entry.description,
              value: MoneyFormatter.format(entry.amount),
              caption:
                  '${entry.isReversed ? 'Reversed' : 'Posted'} · ${DateFormatter.displayDate(entry.postedAt)}',
              muted: entry.isReversed,
            ),
            const Divider(height: 1, color: AppColors.line),
          ],
        ],
        if (finance.dueSchedule.isNotEmpty) ...[
          SizedBox(height: context.s(28)),
          const FigText('Due schedule', style: AppText.screenTitle),
          SizedBox(height: context.s(4)),
          for (final item in finance.dueSchedule) ...[
            _MoneyLine(
              label: item.label,
              value: MoneyFormatter.format(item.amount),
              caption: 'Due ${DateFormatter.displayDate(item.dueAt)}',
            ),
            const Divider(height: 1, color: AppColors.line),
          ],
        ],
      ],
    );
  }
}

class _MoneyLine extends StatelessWidget {
  const _MoneyLine({
    required this.label,
    required this.value,
    this.caption,
    this.muted = false,
    this.emphasis = false,
  });

  final String label;
  final String value;
  final String? caption;
  final bool muted;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final color = muted ? AppColors.muted : AppColors.ink;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigText(label, style: AppText.label, color: color),
                if (caption != null) ...[
                  SizedBox(height: context.s(2)),
                  FigText(caption!, style: AppText.caption),
                ],
              ],
            ),
          ),
          SizedBox(width: context.s(12)),
          FigText(
            value,
            style: muted
                ? AppText.label.copyWith(decoration: TextDecoration.lineThrough)
                : emphasis
                ? AppText.screenTitle
                : AppText.label,
            color: color,
          ),
        ],
      ),
    );
  }
}
