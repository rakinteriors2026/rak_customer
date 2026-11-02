import 'package:flutter/material.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/designs/domain/usecases/request_design_access.dart';
import 'package:rak_customer/features/designs/presentation/design_preview.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_media_viewer_scaffold.dart';

class DesignViewerPage extends StatefulWidget {
  const DesignViewerPage({
    super.key,
    required this.assetId,
    required this.title,
  });

  final String assetId;
  final String title;

  @override
  State<DesignViewerPage> createState() => _DesignViewerPageState();
}

class _DesignViewerPageState extends State<DesignViewerPage> {
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
    final result = await sl<RequestDesignAccess>()(widget.assetId);
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
    return RakMediaViewerScaffold(
      title: widget.title,
      body: _loading
          ? const AppLoading()
          : _unavailable
          ? const Center(
              child: Text(
                'No longer available',
                style: TextStyle(color: AppColors.white),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Image.asset(
                    designPreviewAsset(
                      hint: _access!.visualHint,
                      title: widget.title,
                      assetId: widget.assetId,
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(color: AppColors.ink),
                  ),
                ),
                if (_access?.caption != null)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      _access!.caption!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
                    ),
                  ),
              ],
            ),
    );
  }
}
