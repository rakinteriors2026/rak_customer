import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';

class AppText {
  static const _family = 'Poppins';

  static const display = TextStyle(
    fontFamily: _family,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 42 / 32,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const heading = TextStyle(
    fontFamily: _family,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 34 / 24,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const screenTitle = TextStyle(
    fontFamily: _family,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const title = TextStyle(
    fontFamily: _family,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 27 / 18,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const label = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 22 / 14,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const caption = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    letterSpacing: 0,
    color: AppColors.muted,
  );
}
