import 'package:flutter/material.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/documents/domain/usecases/request_document_access.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';

class DocumentViewerPage extends StatefulWidget {
  const DocumentViewerPage({
    super.key,
    required this.assetId,
    required this.title,
  });

  final String assetId;
  final String title;

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  AssetAccess? _access;
  bool _unavailable = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _recheck();
  }

  Future<void> _recheck() async {
    setState(() {
      _loading = true;
      _unavailable = false;
    });
    final result = await sl<RequestDocumentAccess>()(widget.assetId);
    if (!mounted) return;
    result.fold(
      onSuccess: (access) {
        setState(() {
          _access = access;
          _unavailable = false;
          _loading = false;
        });
      },
      onFailure: (_) {
        setState(() {
          _access = null;
          _unavailable = true;
          _loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = sl<Clock>().now();
    final expired = _access != null && _access!.isExpiredAt(now);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const AppLoading()
          : _unavailable
          ? const Center(child: Text('No longer available'))
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 72,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  expired
                      ? 'Link expired — tap refresh to request a new one.'
                      : 'Opened via a short-lived link. It is not saved on this device.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
                ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton(
                  onPressed: _recheck,
                  child: const Text('Refresh link'),
                ),
              ],
            ),
    );
  }
}
