import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart';

/// iOS scale that undoes the plugin’s 0.01 replacement and restores 0.87 m.
/// The mesh is about 2 units across, so `2 * 0.01 * 43.5 = 0.87`.
const iosArmchairScale = 43.5;

/// Node position that puts the armchair on the floor after [iosArmchairScale].
///
/// The glTF node is translated to Y 40.98595 so its own scale of 43.31 sits
/// the mesh on the floor. The iOS plugin replaces that scale with 0.01 and
/// keeps the translation. Multiplying by [parentScale] would leave the chair
/// about 1.8 km above the tap unless the node moves down by the same amount.
Vector3 iosArmchairFloorPosition(double parentScale) {
  return FurnitureArCatalog.armchair.iosFloorPosition(parentScale);
}

/// Real-world furniture loaded into the AR scene.
///
/// Android fits the model into a cube of [androidMetres] and sits the base
/// on the floor. iOS replaces the file scale with 0.01, so [iosScale] restores
/// the same size and [iosFloorPosition] puts the base on the floor.
class FurnitureArModel {
  const FurnitureArModel({
    required this.name,
    required this.asset,
    required this.min,
    required this.max,
    required this.targetLongestMetres,
    this.heightMetres,
    this.fileScale = 1,
    this.fileTranslationY = 0,
  });

  final String name;
  final String asset;
  final Vector3 min;
  final Vector3 max;

  /// Longest side of the piece once it is standing in the room, in metres.
  final double targetLongestMetres;

  /// Real height in metres. When set, the piece is scaled on Y only so a
  /// tall mesh still stands on the floor at furniture height.
  final double? heightMetres;

  /// Uniform scale written into the glTF node.
  final double fileScale;

  /// glTF node translation on Y. Only the armchair uses one.
  final double fileTranslationY;

  static const iosPluginScale = 0.01;

  Vector3 get _meshSize => max - min;

  double get _meshLongest =>
      math.max(_meshSize.x, math.max(_meshSize.y, _meshSize.z));

  /// Value passed as the node scale on Android. The scene fits the model’s
  /// longest side into this many metres.
  double get androidMetres => targetLongestMetres;

  /// Parent scale on iOS, after the plugin has replaced the file scale.
  double get iosScale => targetLongestMetres / (_meshLongest * iosPluginScale);

  /// iOS scale per axis. Y uses [heightMetres] when the mesh is too tall.
  Vector3 get iosScaleVector {
    final height = heightMetres;
    if (height == null) return Vector3(iosScale, iosScale, iosScale);
    final width = math.max(max.x - min.x, max.z - min.z);
    final horizontal = targetLongestMetres / (width * iosPluginScale);
    final vertical = height / ((max.y - min.y) * iosPluginScale);
    return Vector3(horizontal, vertical, horizontal);
  }

  /// Android node scale after the model has been fitted to [androidMetres].
  /// Y is below 1 when [heightMetres] is shorter than that fit.
  double get androidHeightScale {
    final height = heightMetres;
    if (height == null) return 1;
    final fitted = (max.y - min.y) / _meshLongest * targetLongestMetres;
    return height / fitted;
  }

  Vector3 iosFloorPosition([double? parentScale]) {
    final scale = parentScale ?? iosScaleVector.y;
    final bottom = fileTranslationY + iosPluginScale * min.y;
    return Vector3(0, -scale * bottom, 0);
  }

  /// Transform sent to the platform view.
  ///
  /// On Android the diagonal is the real-world size. On iOS it is the parent
  /// scale, and the translation cancels the leftover file offset.
  Matrix4 placementTransform({required bool ios}) {
    final matrix = Matrix4.identity();
    final scale = ios
        ? iosScaleVector
        : Vector3(androidMetres, androidMetres, androidMetres);
    matrix.setEntry(0, 0, scale.x);
    matrix.setEntry(1, 1, scale.y);
    matrix.setEntry(2, 2, scale.z);
    if (ios) matrix.setTranslation(iosFloorPosition());
    return matrix;
  }

  /// Slide and X/Y/Z rotation. The base stays on the floor.
  ///
  /// Android fits the mesh first, so later updates use a node scale of 1
  /// except for a shorter real height. iOS turns around the floor contact.
  Matrix4 pose({
    required bool ios,
    required double pitch,
    required double yaw,
    required double roll,
    required double slideX,
    required double slideZ,
  }) {
    final rotation = Quaternion.euler(yaw, pitch, roll);
    if (!ios) {
      // The mesh is centered, so half of it would sink through the anchor.
      // Lift by the scaled bottom so the feet stay on the floor.
      final lift = heightMetres == null ? 0.0 : -min.y * androidHeightScale;
      return Matrix4.compose(
        Vector3(slideX, lift, slideZ),
        rotation,
        Vector3(1, androidHeightScale, 1),
      );
    }
    final lift = iosFloorPosition().y;
    final lifted = Matrix4.compose(
      Vector3(0, lift, 0),
      Quaternion.identity(),
      iosScaleVector,
    );
    final spun = Matrix4.compose(
      Vector3(slideX, 0, slideZ),
      rotation,
      Vector3(1, 1, 1),
    );
    return spun * lifted;
  }
}

class FurnitureArCatalog {
  const FurnitureArCatalog._();

  static final armchair = FurnitureArModel(
    name: 'chair',
    asset: 'assets/models/armchair.glb',
    min: Vector3(-0.998926401138306, -0.946243047714233, -1),
    max: Vector3(0.998926401138306, 0.946243047714233, 1),
    fileScale: 43.3143997192383,
    fileTranslationY: 40.9859504699707,
    targetLongestMetres: 0.87,
  );

  static final sofa = FurnitureArModel(
    name: 'sofa',
    asset: 'assets/models/sofa.glb',
    min: Vector3(-1.05, -0.85, -0.45),
    max: Vector3(1.05, 0.85, 0.45),
    targetLongestMetres: 2.2,
  );

  static final table = FurnitureArModel(
    name: 'table',
    asset: 'assets/models/table.glb',
    min: Vector3(-0.8, -0.76, -0.45),
    max: Vector3(0.8, 0.76, 0.45),
    targetLongestMetres: 1.6,
    heightMetres: 0.75,
  );

  static final lamp = FurnitureArModel(
    name: 'lamp',
    asset: 'assets/models/lamp.glb',
    min: Vector3(-0.18, -1.5, -0.18),
    max: Vector3(0.18, 1.5, 0.18),
    targetLongestMetres: 1.7,
  );

  static final wardrobe = FurnitureArModel(
    name: 'wardrobe',
    asset: 'assets/models/wardrobe.glb',
    min: Vector3(-0.62, -2.1, -0.32),
    max: Vector3(0.62, 2.1, 0.32),
    targetLongestMetres: 2.1,
  );

  static final rug = FurnitureArModel(
    name: 'rug',
    asset: 'assets/models/rug.glb',
    min: Vector3(-0.9, -0.015, -0.6),
    max: Vector3(0.9, 0.015, 0.6),
    targetLongestMetres: 2.4,
  );

  static FurnitureArModel forHint(String hint) {
    return switch (hint) {
      'sofa' => sofa,
      'table' => table,
      'light' || 'lamp' => lamp,
      'wardrobe' => wardrobe,
      'rug' => rug,
      _ => armchair,
    };
  }
}
