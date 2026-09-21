import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Unavailable',
      subtitle: 'This item is no longer shared with this account.',
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const Text('The link may have expired, or access was withdrawn.'),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Back to notifications',
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
    );
  }
}
