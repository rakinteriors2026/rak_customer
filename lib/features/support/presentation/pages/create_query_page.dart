import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/create_support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_contexts.dart';
import 'package:rak_customer/features/support/presentation/cubit/create_query_cubit.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
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
                  const FigText('Related to', style: AppText.caption),
                  SizedBox(height: context.s(4)),
                  for (final option in contexts.options) ...[
                    _ContextRow(
                      option: option,
                      selected:
                          selected?.id == option.id &&
                          selected?.kind == option.kind,
                      onTap: submitting
                          ? null
                          : () => context.read<CreateQueryCubit>().select(
                              option,
                            ),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                  ],
                  SizedBox(height: context.s(22)),
                  const FigText('Subject', style: AppText.caption),
                  TextField(
                    controller: _subject,
                    enabled: !submitting,
                    style: AppText.body.fig(context),
                    cursorColor: AppColors.ink,
                    decoration: _line(context, hint: 'Kitchen installation'),
                  ),
                  SizedBox(height: context.s(18)),
                  const FigText('Question', style: AppText.caption),
                  TextField(
                    controller: _message,
                    enabled: !submitting,
                    minLines: 3,
                    maxLines: 6,
                    style: AppText.body.fig(context),
                    cursorColor: AppColors.ink,
                    decoration: _line(
                      context,
                      hint: 'When will the countertop installation begin?',
                    ),
                  ),
                  if (errorMessage != null) ...[
                    SizedBox(height: context.s(12)),
                    FigText(
                      errorMessage,
                      style: AppText.caption,
                      color: AppColors.error,
                    ),
                  ],
                  SizedBox(height: context.s(24)),
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
                ],
              ),
          },
        );
      },
    );
  }
}

class _ContextRow extends StatelessWidget {
  const _ContextRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final SupportContextOption option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final kind = option.kind == SupportContextKind.project
        ? 'Project'
        : 'Order';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(14)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    option.label,
                    style: AppText.label,
                    color: selected ? AppColors.ink : AppColors.muted,
                  ),
                  SizedBox(height: context.s(2)),
                  FigText(kind, style: AppText.caption),
                ],
              ),
            ),
            if (selected)
              Icon(
                CupertinoIcons.checkmark,
                size: context.s(16),
                color: AppColors.ink,
              ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _line(BuildContext context, {required String hint}) {
  const idle = UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.line),
  );
  const focus = UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.ink),
  );
  return InputDecoration(
    filled: false,
    isDense: true,
    hintText: hint,
    hintStyle: AppText.body.fig(context).copyWith(color: AppColors.muted),
    contentPadding: EdgeInsets.symmetric(vertical: context.s(12)),
    border: idle,
    enabledBorder: idle,
    focusedBorder: focus,
    disabledBorder: idle,
  );
}
