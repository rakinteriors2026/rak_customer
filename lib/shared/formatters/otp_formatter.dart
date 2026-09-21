import 'package:flutter/services.dart';

class OtpFormatter {
  static const maxLength = 6;
  static const separator = '  ';

  static String digitsOnly(String value) => value.replaceAll(RegExp(r'\D'), '');

  static String spaced(String value) {
    final digits = digitsOnly(value);
    final limited = digits.length > maxLength
        ? digits.substring(0, maxLength)
        : digits;
    return limited.split('').join(separator);
  }
}

class OtpInputFormatter extends TextInputFormatter {
  const OtpInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = OtpFormatter.spaced(newValue.text);
    final digitsBeforeCursor = OtpFormatter.digitsOnly(
      newValue.text.substring(
        0,
        newValue.selection.end.clamp(0, newValue.text.length),
      ),
    ).length;
    final offset = digitsBeforeCursor == 0
        ? 0
        : (digitsBeforeCursor +
                  (digitsBeforeCursor - 1) * OtpFormatter.separator.length)
              .clamp(0, formatted.length);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
