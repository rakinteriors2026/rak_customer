import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';

enum RakButtonStyle { primary, secondary, destructive, plain }

class RakButton extends StatefulWidget {
  const RakButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = RakButtonStyle.primary,
    this.loading = false,
    this.width,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final RakButtonStyle style;
  final bool loading;
  final double? width;
  final double height;

  @override
  State<RakButton> createState() => _RakButtonState();
}

class _RakButtonState extends State<RakButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    final background = !enabled
        ? (widget.style == RakButtonStyle.plain
              ? Colors.transparent
              : AppColors.line)
        : switch (widget.style) {
            RakButtonStyle.primary => AppColors.buttonPrimary,
            RakButtonStyle.secondary ||
            RakButtonStyle.destructive => AppColors.soft,
            RakButtonStyle.plain => Colors.transparent,
          };
    final foreground = !enabled
        ? AppColors.muted
        : switch (widget.style) {
            RakButtonStyle.primary => AppColors.onPrimary,
            RakButtonStyle.destructive => AppColors.destructive,
            RakButtonStyle.secondary || RakButtonStyle.plain => AppColors.ink,
          };
    final align = widget.style == RakButtonStyle.plain
        ? Alignment.centerLeft
        : Alignment.center;
    final radius = context.s(AppRadii.button);
    return SizedBox(
      height: context.s(widget.height),
      width: widget.width == null ? double.infinity : context.s(widget.width!),
      child: Listener(
        onPointerDown: enabled ? (_) => _setPressed(true) : null,
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed && enabled ? 0.98 : 1,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: FilledButton(
            onPressed: widget.loading ? null : widget.onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: background,
              foregroundColor: foreground,
              disabledBackgroundColor: widget.style == RakButtonStyle.plain
                  ? Colors.transparent
                  : AppColors.line,
              disabledForegroundColor: AppColors.muted,
              padding: EdgeInsets.symmetric(horizontal: context.s(16)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppText.label.fig(context).copyWith(color: foreground),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              alignment: align,
              overlayColor: AppColors.ink.withValues(alpha: 0.08),
            ),
            child: widget.loading
                ? SizedBox(
                    height: context.s(20),
                    width: context.s(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: foreground,
                    ),
                  )
                : Text(widget.label, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
