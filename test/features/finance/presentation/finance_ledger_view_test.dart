import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';
import 'package:rak_customer/features/finance/presentation/widgets/project_finance_section.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';

void main() {
  ProjectFinance fixture() {
    Money aed(int minor) =>
        Money(minorUnits: minor, currency: SeedData.financeCurrency);
    return ProjectFinance(
      projectId: SeedData.alBarariId,
      currency: SeedData.financeCurrency,
      asOf: SeedData.financeAsOf,
      totalContract: aed(SeedData.totalContractMinor),
      approvedVariations: aed(SeedData.approvedVariationsMinor),
      netReceived: aed(SeedData.netReceivedMinor),
      outstandingTotal: aed(SeedData.outstandingTotalMinor),
      amountCurrentlyDue: aed(SeedData.amountCurrentlyDueMinor),
      creditOverpayment: aed(SeedData.creditOverpaymentMinor),
      entries: const [],
      dueSchedule: const [],
    );
  }

  testWidgets('renders server totals and credit exactly as supplied', (
    tester,
  ) async {
    final finance = fixture();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: FinanceLedgerView(finance: finance, stale: true),
          ),
        ),
      ),
    );

    expect(
      find.text(MoneyFormatter.format(finance.totalContract)),
      findsOneWidget,
    );
    expect(
      find.text(MoneyFormatter.format(finance.outstandingTotal)),
      findsOneWidget,
    );
    expect(
      find.text(MoneyFormatter.format(finance.creditOverpayment)),
      findsOneWidget,
    );
    expect(find.text('Credit / overpayment'), findsOneWidget);
    expect(find.textContaining('may be out of date'), findsOneWidget);
  });

  testWidgets('hides credit when the server sends zero', (tester) async {
    final finance = ProjectFinance(
      projectId: SeedData.alBarariId,
      currency: SeedData.financeCurrency,
      asOf: SeedData.financeAsOf,
      totalContract: const Money(minorUnits: 1, currency: 'INR'),
      approvedVariations: const Money(minorUnits: 0, currency: 'INR'),
      netReceived: const Money(minorUnits: 0, currency: 'INR'),
      outstandingTotal: const Money(minorUnits: 1, currency: 'INR'),
      amountCurrentlyDue: const Money(minorUnits: 1, currency: 'INR'),
      creditOverpayment: const Money(minorUnits: 0, currency: 'INR'),
      entries: const [],
      dueSchedule: const [],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: FinanceLedgerView(finance: finance, stale: false)),
      ),
    );

    expect(find.text('Credit / overpayment'), findsNothing);
    expect(find.textContaining('may be out of date'), findsNothing);
  });
}
