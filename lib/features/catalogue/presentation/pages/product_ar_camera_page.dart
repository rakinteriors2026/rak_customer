import 'dart:io';
import 'dart:math' as math;

import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/catalogue/presentation/furniture_ar_placement.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

enum _ArCameraStatus { opening, ready, denied, unsupported }

/// Catalogue size used to scale the camera photo.
/// A phone back camera is treated as a 60° view, 2.5m from the piece.
class _PieceSize {
  const _PieceSize({
    required this.widthM,
    required this.heightM,
    required this.label,
  });

  final double widthM;
  final double heightM;
  final String label;

  static _PieceSize fromSpecs(String? specs, String hint) {
    final text = specs ?? '';
    final width = _centimetres(RegExp(r'W\s*(\d+(?:\.\d+)?)\s*cm'), text);
    final height = _centimetres(RegExp(r'H\s*(\d+(?:\.\d+)?)\s*cm'), text);
    final diameter = _centimetres(
      RegExp(r'Diameter\s*(\d+(?:\.\d+)?)\s*cm'),
      text,
    );
    final pair = RegExp(
      r'(\d+(?:\.\d+)?)\s*[×x]\s*(\d+(?:\.\d+)?)\s*cm',
    ).firstMatch(text);
    if (width != null && height != null) {
      return _PieceSize(
        widthM: width,
        heightM: height,
        label: '${width.roundCm} × ${height.roundCm}cm',
      );
    }
    if (diameter != null) {
      return _PieceSize(
        widthM: diameter,
        heightM: diameter,
        label: '${diameter.roundCm}cm across',
      );
    }
    if (pair != null) {
      final across = double.parse(pair.group(1)!) / 100;
      final down = double.parse(pair.group(2)!) / 100;
      return _PieceSize(
        widthM: across,
        heightM: down,
        label: '${across.roundCm} × ${down.roundCm}cm',
      );
    }
    return switch (hint) {
      'sofa' => const _PieceSize(
        widthM: 2.3,
        heightM: 0.82,
        label: '230 × 82cm',
      ),
      'table' => const _PieceSize(
        widthM: 2.2,
        heightM: 0.76,
        label: '220 × 76cm',
      ),
      'light' => const _PieceSize(
        widthM: 0.42,
        heightM: 0.42,
        label: '42cm across',
      ),
      'wardrobe' => const _PieceSize(
        widthM: 1.2,
        heightM: 2.1,
        label: '120 × 210cm',
      ),
      'rug' => const _PieceSize(
        widthM: 2.4,
        heightM: 1.7,
        label: '240 × 170cm',
      ),
      _ => const _PieceSize(widthM: 0.7, heightM: 0.85, label: '70 × 85cm'),
    };
  }

  /// Width and height on screen for a 60° camera, [distanceM] from the piece.
  Size onScreen(Size view, {double distanceM = 2.5}) {
    final visibleW = 2 * distanceM * math.tan(60 * math.pi / 180 / 2);
    final visibleH = visibleW * view.height / view.width;
    return Size(
      (view.width * widthM / visibleW).clamp(72, view.width * 0.92),
      (view.height * heightM / visibleH).clamp(72, view.height * 0.62),
    );
  }
}

const _armchairSize = _PieceSize(
  widthM: 0.87,
  heightM: 0.82,
  label: 'Armchair · 87cm wide, 82cm tall',
);

/// Upright views of the armchair, every 15°.
const _yawFrameCount = 24;

int _yawFrameIndex(double yaw) {
  final turns = yaw / (2 * math.pi) * _yawFrameCount;
  return turns.round() % _yawFrameCount;
}

String _yawAsset(double yaw) =>
    'assets/models/armchair_yaw_${_yawFrameIndex(yaw).toString().padLeft(2, '0')}.png';

double _yawDegrees(double yaw) {
  final degrees = (yaw * 180 / math.pi) % 360;
  return degrees < 0 ? degrees + 360 : degrees;
}

extension on double {
  int get roundCm => (this * 100).round();
}

double? _centimetres(RegExp pattern, String text) {
  final match = pattern.firstMatch(text);
  if (match == null) return null;
  return double.parse(match.group(1)!) / 100;
}

bool get _floorPlacementSupported {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}

const _floorChannel = MethodChannel(
  'com.rakinteriors.rak_customer/floor_placement',
);

enum _FloorSupport { ready, needsInstall, unsupported }

/// Google Play Services for AR. A supported phone anchors the model, so
/// moving the camera shows every side. This Realme is not on that list.
Future<_FloorSupport> _deviceFloorSupport() async {
  if (!_floorPlacementSupported) return _FloorSupport.unsupported;
  if (!kIsWeb && Platform.isIOS) return _FloorSupport.ready;
  try {
    final name = await _floorChannel.invokeMethod<String>('availability');
    return switch (name) {
      'SUPPORTED_INSTALLED' => _FloorSupport.ready,
      'SUPPORTED_NOT_INSTALLED' ||
      'SUPPORTED_APK_TOO_OLD' => _FloorSupport.needsInstall,
      _ => _FloorSupport.unsupported,
    };
  } catch (_) {
    return _FloorSupport.unsupported;
  }
}

class ProductArCameraPage extends StatefulWidget {
  const ProductArCameraPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.imageHint,
    this.specs,
  });

  final String productId;
  final String productName;
  final String imageHint;
  final String? specs;

  @override
  State<ProductArCameraPage> createState() => _ProductArCameraPageState();
}

class _ProductArCameraPageState extends State<ProductArCameraPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  _ArCameraStatus _status = _ArCameraStatus.opening;
  var _checkingFloor = _floorPlacementSupported;
  var _floorAvailable = false;
  var _floorPlacement = false;
  var _awaitingArInstall = false;
  var _arUnsupported = false;
  var _usePreview = false;
  Offset _offset = Offset.zero;
  double _scale = 1;
  double _rotation = 0;
  double _dial = 0;
  var _baseScale = 1.0;
  var _baseRotation = 0.0;
  var _baseOffset = Offset.zero;
  var _startFocal = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prepare();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _awaitingArInstall) {
      _prepare(promptInstall: false);
    }
  }

  Future<void> _prepare({bool promptInstall = true}) async {
    final support = await _deviceFloorSupport();
    if (!mounted) return;
    if (support == _FloorSupport.needsInstall) {
      if (promptInstall) {
        final status = await _floorChannel.invokeMethod<String>(
          'requestInstall',
        );
        if (!mounted) return;
        if (status == 'INSTALLED') {
          _showFloor();
          return;
        }
      }
      setState(() {
        _checkingFloor = false;
        _floorAvailable = false;
        _floorPlacement = false;
        _awaitingArInstall = true;
        _arUnsupported = false;
      });
      return;
    }
    if (support == _FloorSupport.ready) {
      _showFloor();
      return;
    }
    setState(() {
      _checkingFloor = false;
      _floorAvailable = false;
      _floorPlacement = false;
      _awaitingArInstall = false;
      _arUnsupported = true;
    });
  }

  void _showFloor() {
    setState(() {
      _checkingFloor = false;
      _floorAvailable = true;
      _floorPlacement = true;
      _awaitingArInstall = false;
      _arUnsupported = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  bool _isDenied(CameraException error) {
    return error.code == 'CameraAccessDenied' ||
        error.code == 'CameraAccessDeniedWithoutPrompt' ||
        error.code == 'CameraAccessRestricted';
  }

  Future<void> _openCamera() async {
    setState(() => _status = _ArCameraStatus.opening);
    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      if (cameras.isEmpty) {
        setState(() => _status = _ArCameraStatus.unsupported);
        return;
      }
      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      Object? lastError;
      for (final preset in const [
        ResolutionPreset.veryHigh,
        ResolutionPreset.high,
        ResolutionPreset.medium,
        ResolutionPreset.low,
      ]) {
        final controller = CameraController(camera, preset, enableAudio: false);
        try {
          await controller.initialize();
          await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
          if (!mounted) {
            await controller.dispose();
            return;
          }
          setState(() {
            _controller = controller;
            _status = _ArCameraStatus.ready;
          });
          return;
        } catch (error) {
          lastError = error;
          await controller.dispose();
        }
      }
      if (lastError is CameraException) throw lastError;
      throw lastError ?? CameraException('camera', 'The camera did not open.');
    } on CameraException catch (error) {
      if (!mounted) return;
      setState(() {
        _status = _isDenied(error)
            ? _ArCameraStatus.denied
            : _ArCameraStatus.unsupported;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _ArCameraStatus.unsupported);
    }
  }

  void _usePhoto() {
    setState(() => _floorPlacement = false);
    _openCamera();
  }

  Future<void> _useFloor() async {
    await _controller?.dispose();
    if (!mounted) return;
    setState(() {
      _controller = null;
      _floorPlacement = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingFloor) {
      return RakPage(
        title: 'View in your room',
        subtitle: 'Opening the camera',
        onBack: () => context.pop(),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_floorPlacement) {
      return _FloorPlacement(
        productName: widget.productName,
        imageHint: widget.imageHint,
        onClose: () => context.pop(),
        onUsePhoto: _usePhoto,
      );
    }
    if (_awaitingArInstall) {
      return _Fallback(
        title: 'View in your room',
        subtitle: 'Google AR',
        heading: 'Install Google Play Services for AR',
        message:
            'Google AR keeps the chair where you place it. After the install finishes, come back, tap the floor, then walk around the chair to see every side.',
        primaryLabel: 'Check again',
        onPrimary: () => _prepare(),
        onSecondary: () {
          setState(() {
            _awaitingArInstall = false;
            _usePreview = true;
          });
          _openCamera();
        },
        secondaryLabel: 'Preview on the camera',
      );
    }
    if (_arUnsupported && !_usePreview) {
      return _Fallback(
        title: 'View in your room',
        subtitle: 'Google AR',
        heading: 'This phone cannot keep a piece on the floor',
        message:
            'Google AR is not available on this phone, so a piece cannot stay on the floor while you move the camera. On a supported phone it appears on the floor and stays there while you walk around it.',
        primaryLabel: 'Preview on the camera',
        onPrimary: () {
          setState(() => _usePreview = true);
          _openCamera();
        },
        onSecondary: () => context.pop(),
        secondaryLabel: 'Back to product',
      );
    }
    return switch (_status) {
      _ArCameraStatus.opening => RakPage(
        title: 'View in your room',
        subtitle: 'Opening the camera',
        onBack: () => context.pop(),
        child: const Center(child: CircularProgressIndicator()),
      ),
      _ArCameraStatus.denied => _Fallback(
        title: 'Camera access is off',
        subtitle: 'You’re in control',
        heading: 'Allow access when you’re ready',
        message:
            'Camera access is needed to place this piece in your room. Nothing is recorded.',
        primaryLabel: 'Try camera access again',
        onPrimary: _openCamera,
        onSecondary: () => context.push(
          '/shop/products/${widget.productId}/360',
          extra: widget.productName,
        ),
      ),
      _ArCameraStatus.unsupported => _Fallback(
        title: 'Camera isn’t available',
        subtitle: 'A different way to explore',
        heading: 'This device can’t open the camera',
        message:
            'You can still explore the piece in 360° or go back to the product.',
        primaryLabel: 'Explore product in 360°',
        onPrimary: () => context.push(
          '/shop/products/${widget.productId}/360',
          extra: widget.productName,
        ),
        onSecondary: () => context.pop(),
        secondaryLabel: 'Back to product',
      ),
      _ArCameraStatus.ready => _CameraStage(
        controller: _controller!,
        productName: widget.productName,
        piece: _armchairSize,
        offset: _offset,
        scale: _scale,
        rotation: _rotation,
        yaw: _dial,
        onTryFloor: _floorAvailable ? _useFloor : null,
        photoNote: _arUnsupported
            ? 'Preview only. This phone cannot keep the chair fixed while the camera moves. Slide the dial to see each side.'
            : '${_armchairSize.label}. Drag to move. Pinch to resize. Slide the dial for a full turn.',
        onScaleStart: (details) {
          _baseScale = _scale;
          _baseRotation = _rotation;
          _baseOffset = _offset;
          _startFocal = details.focalPoint;
        },
        onScaleUpdate: (details) {
          setState(() {
            if (details.pointerCount >= 2) {
              _scale = (_baseScale * details.scale).clamp(0.2, 4);
              final slide = details.focalPoint.dx - _startFocal.dx;
              _rotation =
                  _baseRotation +
                  details.rotation -
                  slide * (2 * math.pi) / 280;
              _dial = _yawDegrees(_rotation);
            } else {
              _offset = _baseOffset + (details.focalPoint - _startFocal);
            }
          });
        },
        onRotate: () => setState(() {
          _dial = (_dial + 360 / _yawFrameCount) % 360;
          _rotation = _dial * math.pi / 180;
        }),
        onYaw: (degrees) => setState(() {
          _dial = degrees;
          _rotation = degrees * math.pi / 180;
        }),
        onSmaller: () => setState(() => _scale = (_scale * 0.85).clamp(0.2, 4)),
        onLarger: () => setState(() => _scale = (_scale * 1.18).clamp(0.2, 4)),
        onReset: () => setState(() {
          _offset = Offset.zero;
          _scale = 1;
          _rotation = 0;
          _dial = 0;
        }),
        onClose: () => context.pop(),
      ),
    };
  }
}

/// Platform views drop taps unless they claim the gesture immediately.
/// Without that, a floor ray never reaches the scene and the piece never appears.
class _FloorScene extends StatefulWidget {
  const _FloorScene({required this.onCreated});

  final void Function(
    ARSessionManager session,
    ARObjectManager objects,
    ARAnchorManager anchors,
    ARLocationManager location,
  )
  onCreated;

  @override
  State<_FloorScene> createState() => _FloorSceneState();
}

class _FloorSceneState extends State<_FloorScene> {
  static final _gestures = <Factory<OneSequenceGestureRecognizer>>{
    Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  PermissionStatus? _camera;

  @override
  void initState() {
    super.initState();
    Permission.camera.request().then((status) {
      if (mounted) setState(() => _camera = status);
    });
  }

  void _onPlatformViewCreated(int id) {
    widget.onCreated(
      ARSessionManager(id, context, PlaneDetectionConfig.horizontal),
      ARObjectManager(id),
      ARAnchorManager(id),
      ARLocationManager(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final camera = _camera;
    if (camera == null) {
      return const ColoredBox(color: Colors.black);
    }
    if (camera != PermissionStatus.granted &&
        camera != PermissionStatus.limited) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Allow camera access to place this piece on the floor.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    const params = <String, dynamic>{};
    final view = !kIsWeb && Platform.isIOS
        ? UiKitView(
            viewType: 'ar_flutter_plugin_2',
            layoutDirection: TextDirection.ltr,
            creationParams: params,
            creationParamsCodec: const StandardMessageCodec(),
            gestureRecognizers: _gestures,
            onPlatformViewCreated: _onPlatformViewCreated,
          )
        : AndroidView(
            viewType: 'ar_flutter_plugin_2',
            layoutDirection: TextDirection.ltr,
            creationParams: params,
            creationParamsCodec: const StandardMessageCodec(),
            gestureRecognizers: _gestures,
            onPlatformViewCreated: _onPlatformViewCreated,
          );
    return SizedBox.expand(child: view);
  }
}

class _FloorPlacement extends StatefulWidget {
  const _FloorPlacement({
    required this.productName,
    required this.imageHint,
    required this.onClose,
    required this.onUsePhoto,
  });

  final String productName;
  final String imageHint;
  final VoidCallback onClose;
  final VoidCallback onUsePhoto;

  @override
  State<_FloorPlacement> createState() => _FloorPlacementState();
}

class _FloorPlacementState extends State<_FloorPlacement> {
  ARSessionManager? _session;
  ARObjectManager? _objects;
  ARAnchorManager? _anchors;
  final List<ARAnchor> _placed = [];
  var _floorFound = false;
  var _placedCount = 0;
  var _placing = false;
  String? _notice;
  String? _iosModelName;
  ARNode? _piece;
  var _pitch = 0.0;
  var _yaw = 0.0;
  var _roll = 0.0;
  var _slideX = 0.0;
  var _slideZ = 0.0;

  @override
  void dispose() {
    _session?.dispose();
    super.dispose();
  }

  void _onViewCreated(
    ARSessionManager session,
    ARObjectManager objects,
    ARAnchorManager anchors,
    ARLocationManager location,
  ) {
    _session = session;
    _objects = objects;
    _anchors = anchors;
    session.onError = (error) {
      if (!mounted) return;
      setState(
        () => _notice = 'The piece could not be placed. Try the floor again.',
      );
    };
    session.onPlaneDetected = (count) {
      if (!mounted || count <= 0 || _floorFound) return;
      setState(() => _floorFound = true);
    };
    session.onPlaneOrPointTap = _onPlaneTap;
    session.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      showWorldOrigin: false,
      showAnimatedGuide: true,
      handleTaps: true,
      handlePans: true,
      handleRotation: true,
    );
    objects.onInitialize();
  }

  Future<void> _clear() async {
    for (final anchor in _placed) {
      _anchors?.removeAnchor(anchor);
    }
    _placed.clear();
    _piece = null;
    _pitch = 0;
    _yaw = 0;
    _roll = 0;
    _slideX = 0;
    _slideZ = 0;
    _session?.showPlanes(true);
    if (mounted) setState(() => _placedCount = 0);
  }

  Future<void> _onPlaneTap(List<ARHitTestResult> hits) async {
    if (_placing) return;
    ARHitTestResult? plane;
    for (final hit in hits) {
      if (hit.type == ARHitTestResultType.plane) {
        plane = hit;
        break;
      }
    }
    if (plane == null) return;
    _placing = true;
    try {
      await _clear();
      final anchor = ARPlaneAnchor(transformation: plane.worldTransform);
      final added = await _anchors?.addAnchor(anchor);
      if (added != true) {
        if (mounted) {
          setState(
            () => _notice =
                'The floor is not ready yet. Move the phone a little more.',
          );
        }
        return;
      }
      _placed.add(anchor);
      final model = FurnitureArCatalog.armchair;
      final ios = !kIsWeb && Platform.isIOS;
      final String uri;
      final NodeType type;
      if (ios) {
        try {
          uri = await _copyModelForIos(model.asset);
        } catch (_) {
          await _clear();
          if (mounted) {
            setState(
              () => _notice =
                  'This piece could not be added. Point at the floor again.',
            );
          }
          return;
        }
        type = NodeType.fileSystemAppFolderGLB;
      } else {
        uri = model.asset;
        type = NodeType.localGLTF2;
      }
      final node = ARNode(
        type: type,
        uri: uri,
        transformation: model.placementTransform(ios: ios),
      );
      final attached = await _objects?.addNode(node, planeAnchor: anchor);
      if (!mounted) return;
      if (attached == true) {
        _piece = node;
        _pitch = 0;
        _yaw = 0;
        _roll = 0;
        _slideX = 0;
        _slideZ = 0;
        _applyPose();
        setState(() {
          _placedCount = 1;
          _notice = null;
          _floorFound = true;
        });
      } else {
        setState(
          () => _notice =
              'This piece could not be added. Point at the floor again.',
        );
      }
    } finally {
      _placing = false;
    }
  }

  /// The iOS loader only finds files in the main bundle. Flutter ships this
  /// GLB inside App.framework, so copy it into Documents and load that path.
  Future<String> _copyModelForIos(String asset) async {
    final cached = _iosModelName;
    if (cached != null) return cached;
    final data = await rootBundle.load(asset);
    final docs = await getApplicationDocumentsDirectory();
    final name = asset.split('/').last;
    final file = File('${docs.path}/$name');
    await file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    _iosModelName = name;
    return name;
  }

  /// Puts the armchair on the floor at its real size. Finger gestures move it after that.
  void _applyPose() {
    final piece = _piece;
    if (piece == null) return;
    piece.transform = FurnitureArCatalog.armchair.pose(
      ios: !kIsWeb && Platform.isIOS,
      pitch: _pitch,
      yaw: _yaw,
      roll: _roll,
      slideX: _slideX,
      slideZ: _slideZ,
    );
  }

  String get _instruction {
    final piece = FurnitureArCatalog.armchair.name;
    if (_notice != null) return _notice!;
    if (_placedCount > 0) {
      return 'Drag with one finger to move the $piece. Twist with two fingers to turn it.';
    }
    if (_floorFound) {
      return 'The dotted floor is ready. The $piece appears where you are looking.';
    }
    return 'Point the phone down at the floor. The $piece appears on the floor in front of you.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _FloorScene(onCreated: _onViewCreated),
          if (_placedCount == 0)
            const IgnorePointer(
              child: Align(
                alignment: Alignment(0, 0.16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: SizedBox(width: 22, height: 22),
                ),
              ),
            ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                tooltip: 'Back',
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: AppColors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.ink.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label.copyWith(color: AppColors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _instruction,
                          textAlign: TextAlign.center,
                          style: AppText.caption.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        if (_placedCount > 0) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: RakButton(
                              label: 'Remove',
                              height: 44,
                              onPressed: _clear,
                            ),
                          ),
                        ],
                        TextButton(
                          onPressed: widget.onUsePhoto,
                          child: Text(
                            'Preview without Google AR',
                            style: AppText.caption.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fills the screen the way the phone camera does, without stretching.
class _LiveCamera extends StatelessWidget {
  const _LiveCamera({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final sensorAspect = controller.value.aspectRatio;
    if (!controller.value.isInitialized || sensorAspect == 0) {
      return const SizedBox.shrink();
    }
    final portrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    final previewAspect = portrait ? 1 / sensorAspect : sensorAspect;
    final screenAspect = screen.width / screen.height;
    final cover = screenAspect > previewAspect
        ? screenAspect / previewAspect
        : previewAspect / screenAspect;
    return ClipRect(
      child: Transform.scale(
        scale: cover,
        child: Center(child: CameraPreview(controller)),
      ),
    );
  }
}

class _CameraStage extends StatelessWidget {
  const _CameraStage({
    required this.controller,
    required this.productName,
    required this.piece,
    required this.offset,
    required this.scale,
    required this.rotation,
    required this.yaw,
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.onRotate,
    required this.onYaw,
    required this.onSmaller,
    required this.onLarger,
    required this.onReset,
    required this.onClose,
    required this.photoNote,
    this.onTryFloor,
  });

  final CameraController controller;
  final String productName;
  final _PieceSize piece;
  final Offset offset;
  final double scale;
  final double rotation;
  final double yaw;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;
  final VoidCallback onRotate;
  final ValueChanged<double> onYaw;
  final VoidCallback onSmaller;
  final VoidCallback onLarger;
  final VoidCallback onReset;
  final VoidCallback onClose;
  final String photoNote;
  final VoidCallback? onTryFloor;

  @override
  Widget build(BuildContext context) {
    final frame = piece.onScreen(MediaQuery.sizeOf(context));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: onScaleStart,
            onScaleUpdate: onScaleUpdate,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _LiveCamera(controller: controller),
                Center(
                  child: Transform.translate(
                    offset: offset,
                    child: Transform.scale(
                      scale: scale,
                      child: SizedBox(
                        width: frame.width,
                        height: frame.height,
                        child: Image.asset(
                          _yawAsset(rotation),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.chair_outlined,
                                color: AppColors.white,
                                size: 72,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                tooltip: 'Back',
                onPressed: onClose,
                icon: const Icon(Icons.close, color: AppColors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.ink.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label.copyWith(color: AppColors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          photoNote,
                          textAlign: TextAlign.center,
                          style: AppText.caption.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.white,
                            inactiveTrackColor: AppColors.white.withValues(
                              alpha: 0.35,
                            ),
                            thumbColor: AppColors.white,
                            overlayColor: const Color(0x33FFFFFF),
                            trackHeight: 2,
                          ),
                          child: Slider(
                            value: yaw,
                            min: 0,
                            max: 360,
                            divisions: _yawFrameCount,
                            label: '${yaw.round()}°',
                            onChanged: onYaw,
                          ),
                        ),
                        Text(
                          '${yaw.round()}°',
                          style: AppText.caption.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RakButton(
                                label: 'Turn',
                                height: 44,
                                onPressed: onRotate,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RakButton(
                                label: 'Smaller',
                                height: 44,
                                style: RakButtonStyle.secondary,
                                onPressed: onSmaller,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RakButton(
                                label: 'Larger',
                                height: 44,
                                style: RakButtonStyle.secondary,
                                onPressed: onLarger,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: onReset,
                          child: Text(
                            'Reset',
                            style: AppText.caption.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        if (onTryFloor != null)
                          TextButton(
                            onPressed: onTryFloor,
                            child: Text(
                              'Try floor placement',
                              style: AppText.caption.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({
    required this.title,
    required this.subtitle,
    required this.heading,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    required this.onSecondary,
    this.secondaryLabel = 'Continue with 360° view',
  });

  final String title;
  final String subtitle;
  final String heading;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final String secondaryLabel;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: title,
      subtitle: subtitle,
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          FigText(heading, style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(message, style: AppText.body, color: AppColors.muted),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'Your camera, your choice',
            detail: 'The preview stays on this device and is not recorded.',
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(label: primaryLabel, onPressed: onPrimary),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: secondaryLabel,
            style: RakButtonStyle.secondary,
            onPressed: onSecondary,
          ),
        ],
      ),
    );
  }
}
