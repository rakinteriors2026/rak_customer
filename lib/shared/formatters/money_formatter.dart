import 'package:intl/intl.dart';
import 'package:rak_customer/core/domain/entities/money.dart';

class MoneyFormatter {
  static String format(Money money) {
    final major = money.minorUnits / 100;
    final symbol = switch (money.currency) {
      'INR' => '₹',
      'AED' => 'AED ',
      _ => '${money.currency} ',
    };
    return NumberFormat.currency(
      locale: money.currency == 'INR' ? 'en_IN' : 'en',
      symbol: symbol,
      decimalDigits: major == major.roundToDouble() ? 0 : 2,
    ).format(major);
  }
}
