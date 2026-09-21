import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/create_support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_contexts.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_queries.dart';
import 'package:rak_customer/features/support/presentation/cubit/create_query_cubit.dart';
import 'package:rak_customer/features/support/presentation/cubit/support_list_cubit.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class SupportListPage extends StatelessWidget {
  const SupportListPage({
    super.key,
    this.accountId,
    this.initialSubject,
    this.initialMessage,
  });

  final String? accountId;
  final String? initialSubject;
  final String? initialMessage;

  @override
  Widget build(BuildContext context) {
    if (accountId == null) {
      return RakPage(
        title: 'How can we help?',
        subtitle: 'Your RAK consultant is here for you.',
        child: ListView(
          padding: context.figPagePadding,
          children: [
            Text(
              'Sign in to raise a query about a project or order.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.md),
            RakButton(
              label: 'Sign in',
              onPressed: () => context.push('/login'),
            ),
          ],
        ),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SupportListCubit(
            getSupportQueries: sl<GetSupportQueries>(),
            accountId: accountId!,
          )..load(),
        ),
        BlocProvider(
          create: (_) => CreateQueryCubit(
            getSupportContexts: sl<GetSupportContexts>(),
            createSupportQuery: sl<CreateSupportQuery>(),
            accountId: accountId!,
          )..load(),
        ),
      ],
      child: _SupportHub(
        initialSubject: initialSubject,
        initialMessage: initialMessage,
      ),
    );
  }
}

class _SupportHub extends StatefulWidget {
  const _SupportHub({this.initialSubject, this.initialMessage});

  final String? initialSubject;
  final String? initialMessage;

  @override
  State<_SupportHub> createState() => _SupportHubState();
}

class _SupportHubState extends State<_SupportHub> {
  late final TextEditingController _subject;
  late final TextEditingController _message;

  @override
  void initState() {
    super.initState();
    _subject = TextEditingController(text: widget.initialSubject);
    _message = TextEditingController(text: widget.initialMessage);
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateQueryCubit, CreateQueryState>(
      listener: (context, state) {
        if (state is CreateQuerySuccess) {
          context.go('/support/${state.query.id}');
        }
      },
      child: RakPage(
        title: 'How can we help?',
        subtitle: 'Your RAK consultant is here for you.',
        child: BlocBuilder<CreateQueryCubit, CreateQueryState>(
          builder: (context, formState) {
            return ListView(
              padding: context.figPagePadding,
              children: [
                const RakInfoCard(
                  title: 'Your sales consultant',
                  detail: 'Priya · Project support',
                ),
                const SizedBox(height: AppSpacing.sm),
                ..._form(context, formState),
                const SizedBox(height: AppSpacing.md),
                BlocBuilder<SupportListCubit, SupportListState>(
                  builder: (context, state) {
                    return switch (state) {
                      SupportListLoaded(:final queries) => Column(
                        children: [
                          for (final query in queries)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: RakInfoCard(
                                title:
                                    'Previous query · ${query.status}',
                                detail:
                                    '${query.id} · ${query.subject}',
                                onTap: () =>
                                    context.push('/support/${query.id}'),
                              ),
                            ),
                        ],
                      ),
                      _ => const SizedBox.shrink(),
                    };
                  },
                ),
                Text(
                  'Your question will be routed to the assigned consultant.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _form(BuildContext context, CreateQueryState state) {
    if (state is CreateQueryLoading) {
      return const [AppLoading()];
    }
    if (state is CreateQueryError) {
      return [
        AppErrorState(
          message: state.message,
          onRetry: () => context.read<CreateQueryCubit>().load(),
        ),
      ];
    }
    if (state is CreateQueryNoContext) {
      return [
        Text(
          'Support queries are linked to a project or an order.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ];
    }
    if (state is! CreateQueryReady) return const [];
    final submitting = state.submitting;
    return [
      Text('Related to', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: AppSpacing.xs),
      InputDecorator(
        decoration: const InputDecoration(),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<SupportContextOption>(
            isExpanded: true,
            value: state.selected,
            items: [
              for (final option in state.contexts.options)
                DropdownMenuItem(
                  value: option,
                  child: Text(option.label),
                ),
            ],
            onChanged: submitting
                ? null
                : (option) {
                    if (option != null) {
                      context.read<CreateQueryCubit>().select(option);
                    }
                  },
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      Text('Subject', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: AppSpacing.xs),
      TextField(
        controller: _subject,
        enabled: !submitting,
        decoration: const InputDecoration(hintText: 'Kitchen installation'),
      ),
      const SizedBox(height: AppSpacing.sm),
      TextField(
        controller: _message,
        enabled: !submitting,
        minLines: 1,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'When will the countertop installation begin?',
        ),
      ),
      if (state.errorMessage != null) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          state.errorMessage!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ],
      const SizedBox(height: AppSpacing.sm),
      RakButton(
        label: submitting ? 'Sending…' : 'Send question',
        loading: submitting,
        onPressed: submitting
            ? null
            : () => context.read<CreateQueryCubit>().submit(
                subject: _subject.text,
                message: _message.text,
              ),
      ),
    ];
  }
}
