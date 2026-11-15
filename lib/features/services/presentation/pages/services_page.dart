import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/presentation/cubit/service_list_cubit.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServiceListCubit>()..load(),
      child: const _ServicesView(),
    );
  }
}

class _ServicesView extends StatelessWidget {
  const _ServicesView();

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'What we do',
      subtitle: 'RAK interior services',
      onBack: () => context.pop(),
      child: BlocBuilder<ServiceListCubit, ServiceListState>(
        builder: (context, state) {
          return switch (state) {
            ServiceListLoading() => const AppLoading(),
            ServiceListError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<ServiceListCubit>().load(),
            ),
            ServiceListLoaded(:final services) => _ServicesBody(
              services: services,
            ),
          };
        },
      ),
    );
  }
}

class _ServicesBody extends StatelessWidget {
  const _ServicesBody({required this.services});

  final List<InteriorService> services;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        const FigText(
          'End-to-end interiors, one team.',
          style: AppText.screenTitle,
        ),
        SizedBox(height: context.s(4)),
        const FigText(
          'From the first consultation to the final styling — tap a service '
          'to see how it works.',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(16)),
        for (var i = 0; i < services.length; i++) ...[
          _ServiceCard(
            service: services[i],
            onTap: () => context.push('/services/${services[i].id}'),
          ),
          if (i < services.length - 1) SizedBox(height: context.s(14)),
        ],
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onTap});

  final InteriorService service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(AppRadii.card);
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RakPhoto(asset: service.heroAsset, height: 150, radius: 0),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(14),
                context.s(12),
                context.s(14),
                context.s(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FigText(
                          service.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.title,
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: context.s(14),
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                  SizedBox(height: context.s(4)),
                  FigText(
                    service.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                  ),
                  SizedBox(height: context.s(10)),
                  Row(
                    children: [
                      _Chip(label: service.startingPriceLabel),
                      SizedBox(width: context.s(8)),
                      _Chip(label: service.durationLabel),
                    ],
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

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.s(10),
        vertical: context.s(5),
      ),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(context.s(AppRadii.banner)),
      ),
      child: FigText(label, style: AppText.caption2),
    );
  }
}
