import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/navigation/auth_return.dart';

void main() {
  test('keeps the requested path through the login query', () {
    final login = AuthReturn.loginLocation(from: '/projects/prj_albarari');
    final from = AuthReturn.readFrom(Uri.parse(login));
    expect(from, '/projects/prj_albarari');
    expect(AuthReturn.otpLocation(from: from), '/login/otp?from=%2Fprojects%2Fprj_albarari');
  });

  test('cancel returns to the screen before the protected feature', () {
    expect(AuthReturn.cancelDestination('/checkout'), '/cart');
    expect(AuthReturn.cancelDestination('/orders/ord_1'), '/cart');
    expect(AuthReturn.cancelDestination('/projects'), '/account');
    expect(AuthReturn.cancelDestination('/support/new'), '/support');
    expect(AuthReturn.cancelDestination(null), '/shop');
  });
}
