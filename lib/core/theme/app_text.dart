import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';

/// Fixed minimal type scale. Sizes stay at these point values on every
/// screen width. Title styles stay semibold so Poppins keeps a clear
/// heading weight.
class AppText {
  static const _family = 'Poppins';

  /// Large Title. 26 / 33.
  static const display = TextStyle(
    fontFamily: _family,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 33 / 26,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  /// Title. 20 / 26.
  static const heading = TextStyle(
    fontFamily: _family,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 26 / 20,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  /// Title 2. 18 / 22.
  static const screenTitle = TextStyle(
    fontFamily: _family,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 22 / 18,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  /// Title 3. 16 / 20.
  static const title = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 20 / 16,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  /// Headline. 14 / 18, semibold.
  static const label = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 18 / 14,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  /// Body. 14 / 18.
  static const body = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 18 / 14,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  /// Body. Same reading size as [body].
  static const bodyLarge = body;

  /// Caption 1. 12 / 16.
  static const caption = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
    color: AppColors.muted,
  );

  /// Caption 2. 11 / 14.
  static const caption2 = TextStyle(
    fontFamily: _family,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 14 / 11,
    letterSpacing: 0,
    color: AppColors.muted,
  );
}
