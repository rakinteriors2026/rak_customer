import 'package:flutter/material.dart';
import 'package:rak_customer/app/app.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final sessionCubit = sl<SessionCubit>();
  await sessionCubit.restore();
  runApp(RakCustomerApp(sessionCubit: sessionCubit));
}
