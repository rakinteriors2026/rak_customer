import 'package:flutter/material.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';
import 'package:rak_customer/features/updates/domain/usecases/request_asset_access.dart';
import 'package:rak_customer/features/updates/presentation/pages/asset_viewer_page.dart';
import 'package:rak_customer/features/updates/presentation/widgets/site_photo.dart';

class AssetThumbnail extends StatefulWidget {
  const AssetThumbnail({super.key, required this.assetId});

  final String assetId;

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  AssetAccess? _access;
  bool _withdrawn = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final result = await sl<RequestAssetAccess>()(widget.assetId);
    if (!mounted) return;
    result.fold(
      onSuccess: (access) {
        setState(() {
          _access = access;
          _withdrawn = false;
          _loading = false;
        });
      },
      onFailure: (_) {
        setState(() {
          _access = null;
          _withdrawn = true;
          _loading = false;
        });
      },
    );
  }

  Future<void> _open() async {
    if (_withdrawn) return;
    final now = sl<Clock>().now();
    if (_access == null || _access!.isExpiredAt(now)) {
      await _resolve();
    }
    if (!mounted || _withdrawn) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AssetViewerPage(assetId: widget.assetId),
      ),
    );
    if (mounted) await _resolve();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      child: InkWell(
        onTap: _withdrawn ? null : _open,
        child: AspectRatio(
          aspectRatio: 1,
          child: _loading
              ? const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _withdrawn
              ? const WithdrawnPhotoPlaceholder(compact: true)
              : SitePhoto(access: _access!, compact: true),
        ),
      ),
    );
  }
}
