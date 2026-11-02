import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/navigation/auth_return.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/create_support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_contexts.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_queries.dart';
import 'package:rak_customer/features/support/presentation/cubit/create_query_cubit.dart';
import 'package:rak_customer/features/support/presentation/cubit/support_list_cubit.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
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
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/account');
          }
        },
        child: ListView(
          padding: context.figPagePadding,
          children: [
            const FigText(
              'Sign in to ask about a project or an order.',
              style: AppText.body,
              color: AppColors.muted,
            ),
            const SizedBox(height: AppSpacing.md),
            RakButton(
              label: 'Sign in',
              onPressed: () =>
                  context.push(AuthReturn.loginLocation(from: '/support')),
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
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/account');
          }
        },
        child: BlocBuilder<CreateQueryCubit, CreateQueryState>(
          builder: (context, formState) {
            return ListView(
              padding: context.figPagePadding,
              children: [
                const FigText('Priya', style: AppText.screenTitle),
                SizedBox(height: context.s(2)),
                const FigText(
                  'Your consultant · Project support',
                  style: AppText.caption,
                ),
                SizedBox(height: context.s(20)),
                const Divider(height: 1, color: AppColors.line),
                SizedBox(height: context.s(20)),
                ..._form(context, formState),
                SizedBox(height: context.s(28)),
                BlocBuilder<SupportListCubit, SupportListState>(
                  builder: (context, state) {
                    if (state is! SupportListLoaded || state.queries.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FigText('Earlier questions', style: AppText.caption),
                        SizedBox(height: context.s(8)),
                        const Divider(height: 1, color: AppColors.line),
                        for (final query in state.queries) ...[
                          _QuietLink(
                            title: query.subject,
                            detail:
                                '${query.statusLabel} · ${DateFormatter.displayShort(query.createdAt)}',
                            onTap: () => context.push('/support/${query.id}'),
                          ),
                          const Divider(height: 1, color: AppColors.line),
                        ],
                      ],
                    );
                  },
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
      return const [
        FigText(
          'A question needs a project or an order.',
          style: AppText.body,
          color: AppColors.muted,
        ),
      ];
    }
    if (state is! CreateQueryReady) return const [];
    final submitting = state.submitting;
    final fieldStyle = AppText.body.fig(context);
    return [
      const FigText('Related to', style: AppText.caption),
      DropdownButtonHideUnderline(
        child: DropdownButton<SupportContextOption>(
          isExpanded: true,
          isDense: true,
          value: state.selected,
          style: fieldStyle.copyWith(color: AppColors.ink),
          icon: Icon(
            CupertinoIcons.chevron_down,
            size: context.s(14),
            color: AppColors.muted,
          ),
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
      const Divider(height: 1, color: AppColors.line),
      SizedBox(height: context.s(18)),
      const FigText('Subject', style: AppText.caption),
      TextField(
        controller: _subject,
        enabled: !submitting,
        style: fieldStyle,
        cursorColor: AppColors.ink,
        decoration: _line(context, hint: 'Kitchen installation'),
      ),
      SizedBox(height: context.s(18)),
      const FigText('Question', style: AppText.caption),
      TextField(
        controller: _message,
        enabled: !submitting,
        minLines: 2,
        maxLines: 5,
        style: fieldStyle,
        cursorColor: AppColors.ink,
        decoration: _line(
          context,
          hint: 'When will the countertop installation begin?',
        ),
      ),
      if (state.errorMessage != null) ...[
        SizedBox(height: context.s(12)),
        FigText(
          state.errorMessage!,
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
    ];
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

class _QuietLink extends StatelessWidget {
  const _QuietLink({
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(16)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(title, style: AppText.label),
                  SizedBox(height: context.s(2)),
                  FigText(detail, style: AppText.caption),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: context.s(14),
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
