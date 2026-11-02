import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rak_customer/app/app.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.statusBar);
  await configureDependencies();
  final sessionCubit = sl<SessionCubit>();
  await sessionCubit.restore();
  runApp(RakCustomerApp(sessionCubit: sessionCubit));
}
