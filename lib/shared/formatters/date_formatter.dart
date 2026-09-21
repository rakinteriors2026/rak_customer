import 'package:intl/intl.dart';

class DateFormatter {
  static String displayDate(DateTime utc) {
    return DateFormat.yMMMd().format(utc.toLocal());
  }

  static String displayShort(DateTime utc) {
    return DateFormat('d MMM yyyy').format(utc.toLocal());
  }

  static String relative(DateTime utc, DateTime now) {
    final local = utc.toLocal();
    final nowLocal = now.toLocal();
    final diff = nowLocal.difference(local);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return displayDate(utc);
  }
}
