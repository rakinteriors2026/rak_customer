import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

enum RakHeroArt {
  welcome('assets/photos/hero_welcome.jpg', AppLayout.heroWelcomeHeight),
  home('assets/photos/hero_home.png', AppLayout.heroHomeHeight),
  product(
    'assets/products/linen_lounge_chair.png',
    AppLayout.heroProductHeight,
  );

  const RakHeroArt(this.asset, this.designHeight);

  final String asset;
  final double designHeight;
}

class RakHeroRoom extends StatelessWidget {
  const RakHeroRoom({
    super.key,
    this.art = RakHeroArt.welcome,
    this.editorial = false,
  });

  final RakHeroArt art;
  final bool editorial;

  @override
  Widget build(BuildContext context) {
    if (!editorial) {
      return RakPhoto(asset: art.asset, height: art.designHeight);
    }

    final height = context.s(art.designHeight);
    final radius = context.s(AppRadii.button);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              art.asset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xF5251F20),
                    Color(0xA3251F20),
                    Color(0x26251F20),
                  ],
                  stops: [0, 0.62, 1],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(20),
                context.s(28),
                context.s(20),
                context.s(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    'RAK  /  CONSIDERED LIVING',
                    style: AppText.caption.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      letterSpacing: 1,
                      height: 1.5,
                    ),
                    color: AppColors.white,
                  ),
                  SizedBox(height: context.s(8)),
                  FigText(
                    'A home,\ncoming together.',
                    style: AppText.heading.copyWith(height: 1.5),
                    color: AppColors.white,
                  ),
                  const Spacer(),
                  FigText(
                    'PROJECT INTERIOR',
                    style: AppText.caption.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 9,
                      letterSpacing: 0.8,
                    ),
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
