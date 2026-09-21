import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/shared/widgets/rak_reveal.dart';
import 'package:rak_customer/shared/widgets/rak_screen_header.dart';

class RakPage extends StatelessWidget {
  const RakPage({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.header,
    this.onBack,
    this.bottomBar,
    this.contentGap,
  }) : assert(header != null || (title != null && subtitle != null));

  final String? title;
  final String? subtitle;
  final Widget? header;
  final Widget child;
  final VoidCallback? onBack;
  final Widget? bottomBar;
  final double? contentGap;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    // Use the screen size, not the keyboard-shrunk body height. Scaffold
    // removes viewInsets from its body, so LayoutBuilder constraints drop
    // below 560 as soon as the keyboard opens and would otherwise swap
    // this tree and unfocus the field.
    final compact = MediaQuery.sizeOf(context).height < 560;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: bottomBar == null,
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboard),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final header =
                  this.header ??
                  RakScreenHeader(
                    title: title!,
                    subtitle: subtitle!,
                    onBack: onBack,
                    contentGap: compact ? 12 : contentGap,
                  );
              if (compact) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        header,
                        SizedBox(
                          height: (constraints.maxHeight * 0.45).clamp(
                            160.0,
                            360.0,
                          ),
                          child: RakReveal(
                            key: const ValueKey('rak.page.body'),
                            child: child,
                          ),
                        ),
                        ?bottomBar,
                      ],
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  Expanded(
                    child: RakReveal(
                      key: const ValueKey('rak.page.body'),
                      child: child,
                    ),
                  ),
                  ?bottomBar,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
