import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/documents/domain/usecases/request_document_access.dart';
import 'package:rak_customer/features/documents/presentation/document_preview.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

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
      appBar: AppBar(
        title: Text(widget.title),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const Icon(CupertinoIcons.chevron_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: _loading
          ? const AppLoading()
          : _unavailable
          ? const Center(child: Text('No longer available'))
          : ListView(
              padding: context.figPagePadding,
              children: [
                RakPhoto(
                  asset: documentPreviewAsset(
                    assetId: widget.assetId,
                    title: widget.title,
                  ),
                  height: 220,
                ),
                SizedBox(height: context.s(16)),
                FigText(widget.title, style: AppText.screenTitle),
                SizedBox(height: context.s(6)),
                FigText(
                  expired
                      ? 'This link has expired. Refresh it to open the file again.'
                      : 'Opened with a short-lived link. The file is not saved on this phone.',
                  style: AppText.body,
                  color: AppColors.muted,
                ),
                SizedBox(height: context.s(8)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _recheck,
                    child: const Text('Refresh link'),
                  ),
                ),
              ],
            ),
    );
  }
}
