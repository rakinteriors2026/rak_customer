import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        path.startsWith('/checkout') ||
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
              elevation: 12,
              shadowColor: const Color(0x14000000),
              child: SafeArea(
                top: false,
                minimum: EdgeInsets.only(bottom: context.s(6)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.s(8),
                    context.s(14),
                    context.s(8),
                    0,
                  ),
                  child: Row(
                    children: [
                      _Tab(
                        label: 'Home',
                        icon: CupertinoIcons.house,
                        selectedIcon: CupertinoIcons.house_fill,
                        selected: navigationShell.currentIndex == 0,
                        onTap: () => navigationShell.goBranch(0),
                      ),
                      _Tab(
                        label: 'Shop',
                        icon: CupertinoIcons.bag,
                        selectedIcon: CupertinoIcons.bag_fill,
                        selected: navigationShell.currentIndex == 1,
                        onTap: () => navigationShell.goBranch(1),
                      ),
                      _Tab(
                        label: 'Cart',
                        icon: CupertinoIcons.cart,
                        selectedIcon: CupertinoIcons.cart_fill,
                        selected: navigationShell.currentIndex == 2,
                        onTap: () => navigationShell.goBranch(2),
                      ),
                      _Tab(
                        label: 'Orders',
                        icon: CupertinoIcons.cube_box,
                        selectedIcon: CupertinoIcons.cube_box_fill,
                        selected: navigationShell.currentIndex == 3,
                        onTap: () => navigationShell.goBranch(3),
                      ),
                      _Tab(
                        label: 'Account',
                        icon: CupertinoIcons.person,
                        selectedIcon: CupertinoIcons.person_fill,
                        selected: navigationShell.currentIndex == 4,
                        onTap: () => navigationShell.goBranch(4),
                      ),
                    ],
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
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.muted;
    final iconSize = context.s(AppLayout.navIcon);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.accent.withValues(alpha: 0.10),
        highlightColor: AppColors.accent.withValues(alpha: 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? selectedIcon : icon, color: color, size: iconSize),
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
