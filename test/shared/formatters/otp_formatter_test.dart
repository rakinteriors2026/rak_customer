import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/shared/formatters/otp_formatter.dart';

void main() {
  test('spaces digits to match the OTP field design', () {
    expect(OtpFormatter.spaced('123456'), '1  2  3  4  5  6');
  });

  test('keeps only the first six digits', () {
    expect(OtpFormatter.spaced('123456789'), '1  2  3  4  5  6');
  });

  test('strips non-digits', () {
    expect(OtpFormatter.digitsOnly('1  2  3  4  5  6'), '123456');
  });

  testWidgets('OTP field shows a space between each digit', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TextField(inputFormatters: [OtpInputFormatter()])),
      ),
    );
    await tester.enterText(find.byType(TextField), '123456');
    expect(find.text('1  2  3  4  5  6'), findsOneWidget);
  });
}
