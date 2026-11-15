import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/presentation/cubit/service_detail_cubit.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({super.key, required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServiceDetailCubit>()..load(serviceId),
      child: _ServiceDetailView(serviceId: serviceId),
    );
  }
}

class _ServiceDetailView extends StatelessWidget {
  const _ServiceDetailView({required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
      builder: (context, state) {
        return switch (state) {
          ServiceDetailLoading() => RakPage(
            title: 'Our service',
            subtitle: 'A RAK interior service',
            onBack: () => context.pop(),
            child: const AppLoading(),
          ),
          ServiceDetailError(:final message) => RakPage(
            title: 'Our service',
            subtitle: 'A RAK interior service',
            onBack: () => context.pop(),
            child: AppErrorState(
              message: message,
              onRetry: () =>
                  context.read<ServiceDetailCubit>().load(serviceId),
            ),
          ),
          ServiceDetailLoaded(:final service) => RakPage(
            title: service.name,
            subtitle: service.tagline,
            onBack: () => context.pop(),
            bottomBar: _EnquireBar(service: service),
            child: _ServiceBody(service: service),
          ),
        };
      },
    );
  }
}

class _ServiceBody extends StatelessWidget {
  const _ServiceBody({required this.service});

  final InteriorService service;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        RakPhoto(asset: service.heroAsset, height: 220),
        SizedBox(height: context.s(16)),
        FigText(service.summary, style: AppText.heading),
        SizedBox(height: context.s(16)),
        Row(
          children: [
            _Stat(label: 'From', value: service.startingPriceLabel),
            SizedBox(width: context.s(12)),
            _Stat(label: 'Typical time', value: service.durationLabel),
          ],
        ),
        SizedBox(height: context.s(22)),
        const FigText('About this service', style: AppText.screenTitle),
        SizedBox(height: context.s(6)),
        FigText(service.description, style: AppText.body),
        SizedBox(height: context.s(24)),
        const FigText("What's included", style: AppText.screenTitle),
        SizedBox(height: context.s(10)),
        for (final highlight in service.highlights) ...[
          _Highlight(text: highlight),
          SizedBox(height: context.s(10)),
        ],
        SizedBox(height: context.s(12)),
        const FigText('How it works', style: AppText.screenTitle),
        SizedBox(height: context.s(4)),
        const FigText(
          'A simple, guided flow from start to finish.',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(14)),
        for (var i = 0; i < service.steps.length; i++)
          _StepRow(
            index: i + 1,
            step: service.steps[i],
            isLast: i == service.steps.length - 1,
          ),
        SizedBox(height: context.s(10)),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(context.s(14)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.s(16)),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FigText(label, style: AppText.caption),
            SizedBox(height: context.s(4)),
            FigText(value, style: AppText.title),
          ],
        ),
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: context.s(6)),
          width: context.s(6),
          height: context.s(6),
          decoration: const BoxDecoration(
            color: AppColors.brass,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.s(12)),
        Expanded(child: FigText(text, style: AppText.body)),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.step,
    required this.isLast,
  });

  final int index;
  final ServiceStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: context.s(32),
                height: context.s(32),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: FigText(
                  '$index',
                  style: AppText.label,
                  color: AppColors.onPrimary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: context.s(2),
                    color: AppColors.line,
                  ),
                ),
            ],
          ),
          SizedBox(width: context.s(14)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : context.s(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.s(5)),
                  FigText(step.title, style: AppText.label),
                  SizedBox(height: context.s(4)),
                  FigText(step.detail, style: AppText.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnquireBar extends StatelessWidget {
  const _EnquireBar({required this.service});

  final InteriorService service;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.canvas,
      padding: EdgeInsets.fromLTRB(
        context.s(24),
        context.s(12),
        context.s(24),
        context.s(12),
      ),
      child: SafeArea(
        top: false,
        child: RakButton(
          label: 'Enquire about ${service.name}',
          onPressed: () {
            final uri = Uri(
              path: '/support',
              queryParameters: {
                'subject': service.name,
                'message':
                    'I would like to know more about your '
                    '${service.name} service.',
              },
            );
            context.go(uri.toString());
          },
        ),
      ),
    );
  }
}
