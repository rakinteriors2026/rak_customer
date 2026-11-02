import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/app/router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/favourites_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';

class RakCustomerApp extends StatelessWidget {
  const RakCustomerApp({super.key, required this.sessionCubit});

  final SessionCubit sessionCubit;

  @override
  Widget build(BuildContext context) {
    final router = createRouter(sessionCubit);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sessionCubit),
        BlocProvider.value(value: sl<FavouritesCubit>()),
        BlocProvider.value(value: sl<ShopBranchCubit>()),
      ],
      child: MaterialApp.router(
        title: 'RAK Interiors',
        theme: AppTheme.light(),
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.statusBar,
            child: child ?? const SizedBox.shrink(),
          );
        },
        routerConfig: router,
      ),
    );
  }
}
