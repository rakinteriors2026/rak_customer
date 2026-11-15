import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/app/router.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
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
          Widget content = child ?? const SizedBox.shrink();
          // F-01: make a release demo build (ALLOW_DEMO=true) unmistakable so
          // it can't be confused with production.
          if (LocalDemoConfig.isReleaseDemoBuild) {
            content = Banner(
              message: 'DEMO BUILD',
              location: BannerLocation.topEnd,
              color: const Color(0xFFB00020),
              child: content,
            );
          }
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.statusBar,
            child: content,
          );
        },
        routerConfig: router,
      ),
    );
  }
}
