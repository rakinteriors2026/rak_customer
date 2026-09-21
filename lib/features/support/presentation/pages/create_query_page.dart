import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/support/domain/usecases/create_support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_contexts.dart';
import 'package:rak_customer/features/support/presentation/cubit/create_query_cubit.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class CreateQueryPage extends StatelessWidget {
  const CreateQueryPage({
    super.key,
    required this.accountId,
    this.prefilledProjectId,
    this.prefilledOrderId,
  });

  final String accountId;
  final String? prefilledProjectId;
  final String? prefilledOrderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateQueryCubit(
        getSupportContexts: sl<GetSupportContexts>(),
        createSupportQuery: sl<CreateSupportQuery>(),
        accountId: accountId,
        prefilledProjectId: prefilledProjectId,
        prefilledOrderId: prefilledOrderId,
      )..load(),
      child: const _CreateQueryView(),
    );
  }
}

class _CreateQueryView extends StatefulWidget {
  const _CreateQueryView();

  @override
  State<_CreateQueryView> createState() => _CreateQueryViewState();
}

class _CreateQueryViewState extends State<_CreateQueryView> {
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateQueryCubit, CreateQueryState>(
      listener: (context, state) {
        if (state is CreateQuerySuccess) {
          context.go('/support/${state.query.id}');
        }
      },
      builder: (context, state) {
        return RakPage(
          title: 'How can we help?',
          subtitle: 'Your RAK consultant is here for you.',
          onBack: () => context.pop(),
          child: switch (state) {
            CreateQueryLoading() => const AppLoading(),
            CreateQueryNoContext() => const AppEmptyState(
              title: 'You need a project or order',
              message:
                  'Support queries are linked to a project or an order. Browse the shop, or wait until a project is linked to your account.',
              icon: Icons.support_agent_outlined,
            ),
            CreateQueryError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<CreateQueryCubit>().load(),
            ),
            CreateQuerySuccess() => const AppLoading(),
            CreateQueryReady(
              :final contexts,
              :final selected,
              :final submitting,
              :final errorMessage,
            ) =>
              ListView(
                padding: context.figPagePadding,
                children: [
                  Text(
                    'Related to',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      for (final option in contexts.options)
                        ChoiceChip(
                          label: Text(option.label),
                          selected:
                              selected?.id == option.id &&
                              selected?.kind == option.kind,
                          onSelected: submitting
                              ? null
                              : (_) => context.read<CreateQueryCubit>().select(
                                  option,
                                ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _subject,
                    enabled: !submitting,
                    decoration: const InputDecoration(hintText: 'Subject'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _message,
                    enabled: !submitting,
                    minLines: 4,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      hintText: 'Your question',
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: submitting
                        ? null
                        : () => context.read<CreateQueryCubit>().submit(
                            subject: _subject.text,
                            message: _message.text,
                          ),
                    child: Text(submitting ? 'Sending…' : 'Send question'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Your question will be routed to the assigned consultant.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
          },
        );
      },
    );
  }
}
