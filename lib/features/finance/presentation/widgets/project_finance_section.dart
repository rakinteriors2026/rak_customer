import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';
import 'package:rak_customer/features/finance/domain/usecases/get_project_finance.dart';
import 'package:rak_customer/features/finance/presentation/cubit/finance_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Figure(
                  label: 'Total contract value',
                  value: MoneyFormatter.format(finance.totalContract),
                ),
                _Figure(
                  label: 'Approved variations',
                  value: MoneyFormatter.format(finance.approvedVariations),
                ),
                _Figure(
                  label: 'Net received',
                  value: MoneyFormatter.format(finance.netReceived),
                ),
                _Figure(
                  label: 'Outstanding total',
                  value: MoneyFormatter.format(finance.outstandingTotal),
                ),
                _Figure(
                  label: 'Amount currently due',
                  value: MoneyFormatter.format(finance.amountCurrentlyDue),
                ),
                if (finance.hasCredit)
                  _Figure(
                    label: 'Credit / overpayment',
                    value: MoneyFormatter.format(finance.creditOverpayment),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  stale
                      ? 'Figures as of ${DateFormatter.displayDate(finance.asOf)} — may be out of date'
                      : 'Figures as of ${DateFormatter.displayDate(finance.asOf)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: stale ? AppColors.warning : AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Ledger', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        ...finance.entries.map(
          (entry) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(entry.description),
            subtitle: Text(
              '${entry.isReversed ? 'Reversed' : 'Posted'} · ${DateFormatter.displayDate(entry.postedAt)}',
            ),
            trailing: Text(MoneyFormatter.format(entry.amount)),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Due schedule', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        ...finance.dueSchedule.map(
          (item) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item.label),
            subtitle: Text('Due ${DateFormatter.displayDate(item.dueAt)}'),
            trailing: Text(MoneyFormatter.format(item.amount)),
          ),
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
