import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final hideNav =
        path == '/cart' ||
        path == '/checkout' ||
        path.contains('/products/') ||
        path.contains('/visualise') ||
        path.startsWith('/sales-kit') ||
        path.contains('/review');
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: navigationShell,
      bottomNavigationBar: hideNav
          ? null
          : Material(
              color: AppColors.surface,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: context.s(AppLayout.navBarHeight),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.s(8),
                      context.s(10),
                      context.s(8),
                      context.s(20),
                    ),
                    child: Row(
                      children: [
                        _Tab(
                          label: 'Home',
                          asset: 'nav_home',
                          selected: navigationShell.currentIndex == 0,
                          onTap: () => navigationShell.goBranch(0),
                        ),
                        _Tab(
                          label: 'Projects',
                          asset: 'nav_projects',
                          selected: navigationShell.currentIndex == 1,
                          onTap: () => navigationShell.goBranch(1),
                        ),
                        _Tab(
                          label: 'Shop',
                          asset: 'nav_shop',
                          selected: navigationShell.currentIndex == 2,
                          onTap: () => navigationShell.goBranch(2),
                        ),
                        _Tab(
                          label: 'Support',
                          asset: 'nav_support',
                          selected: navigationShell.currentIndex == 3,
                          onTap: () => navigationShell.goBranch(3),
                        ),
                        _Tab(
                          label: 'Account',
                          asset: 'nav_account',
                          selected: navigationShell.currentIndex == 4,
                          onTap: () => navigationShell.goBranch(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.muted;
    final icon = context.s(AppLayout.navIcon);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.accent.withValues(alpha: 0.10),
        highlightColor: AppColors.accent.withValues(alpha: 0.05),
        child: Column(
          children: [
            SizedBox(
              width: icon,
              height: icon,
              child: SvgPicture.asset(
                'assets/icons/${asset}_${selected ? 'active' : 'idle'}.svg',
                width: icon,
                height: icon,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: context.s(AppLayout.navGap)),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.fig(context).copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
