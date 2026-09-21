import 'package:rak_customer/core/domain/entities/money.dart';

class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.description,
    required this.state,
    required this.amount,
    required this.postedAt,
  });

  final String id;
  final String description;
  final String state;
  final Money amount;
  final DateTime postedAt;

  bool get isReversed => state == 'reversed';
}

class DueScheduleItem {
  const DueScheduleItem({
    required this.id,
    required this.label,
    required this.amount,
    required this.dueAt,
  });

  final String id;
  final String label;
  final Money amount;
  final DateTime dueAt;
}

class ProjectFinance {
  const ProjectFinance({
    required this.projectId,
    required this.currency,
    required this.asOf,
    required this.totalContract,
    required this.approvedVariations,
    required this.netReceived,
    required this.outstandingTotal,
    required this.amountCurrentlyDue,
    required this.creditOverpayment,
    required this.entries,
    required this.dueSchedule,
  });

  final String projectId;
  final String currency;
  final DateTime asOf;
  final Money totalContract;
  final Money approvedVariations;
  final Money netReceived;
  final Money outstandingTotal;
  final Money amountCurrentlyDue;
  final Money creditOverpayment;
  final List<LedgerEntry> entries;
  final List<DueScheduleItem> dueSchedule;

  bool get hasCredit => creditOverpayment.minorUnits > 0;

  bool isStaleAt(DateTime now, Duration threshold) {
    return now.toUtc().difference(asOf.toUtc()) > threshold;
  }
}
