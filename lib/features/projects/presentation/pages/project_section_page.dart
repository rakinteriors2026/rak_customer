import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class ProjectSectionPage extends StatelessWidget {
  const ProjectSectionPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: title,
      subtitle: subtitle,
      onBack: () => context.go('/projects'),
      child: ListView(padding: context.figPagePadding, children: [child]),
    );
  }
}
