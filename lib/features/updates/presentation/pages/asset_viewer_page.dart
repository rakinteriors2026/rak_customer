import 'package:flutter/material.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';
import 'package:rak_customer/features/updates/domain/usecases/request_asset_access.dart';
import 'package:rak_customer/features/updates/presentation/widgets/site_photo.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_media_viewer_scaffold.dart';

class AssetViewerPage extends StatefulWidget {
  const AssetViewerPage({super.key, required this.assetId});

  final String assetId;

  @override
  State<AssetViewerPage> createState() => _AssetViewerPageState();
}

class _AssetViewerPageState extends State<AssetViewerPage> {
  AssetAccess? _access;
  bool _withdrawn = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _recheck();
  }

  Future<void> _recheck() async {
    setState(() {
      _loading = true;
      _withdrawn = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return RakMediaViewerScaffold(
      title: 'Photo',
      body: _loading
          ? const AppLoading()
          : _withdrawn
          ? const Center(child: WithdrawnPhotoPlaceholder())
          : Column(
              children: [
                Expanded(child: SitePhoto(access: _access!)),
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
