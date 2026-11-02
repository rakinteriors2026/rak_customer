import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/features/catalogue/presentation/furniture_ar_placement.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  test('iOS scale puts the armchair on the floor at real size', () {
    const pluginScale = 0.01;
    const fileTranslationY = 40.9859504699707;
    const meshMinY = -0.946243047714233;
    const meshMaxY = 0.946243047714233;
    const meshWidth = 1.997852802276612;
    final chair = FurnitureArCatalog.armchair;
    final position = iosArmchairFloorPosition(iosArmchairScale);

    double world(double mesh, double translation) =>
        position.y + iosArmchairScale * (translation + pluginScale * mesh);

    expect(chair.iosScale, closeTo(iosArmchairScale, 0.001));
    expect(world(meshMinY, fileTranslationY), closeTo(0, 0.0001));
    expect(
      world(meshMaxY, fileTranslationY) - world(meshMinY, fileTranslationY),
      closeTo(0.823, 0.001),
    );
    expect(meshWidth * pluginScale * iosArmchairScale, closeTo(0.87, 0.002));
    expect(position.x, 0);
    expect(position.z, 0);
  });

  test('each piece sits on the floor at its real size', () {
    for (final model in [
      FurnitureArCatalog.sofa,
      FurnitureArCatalog.table,
      FurnitureArCatalog.lamp,
      FurnitureArCatalog.wardrobe,
      FurnitureArCatalog.rug,
    ]) {
      final position = model.iosFloorPosition();
      final bottom =
          position.y +
          model.iosScaleVector.y *
              (model.fileTranslationY + 0.01 * model.min.y);
      final longest =
          model.iosScale *
          0.01 *
          [
            model.max.x - model.min.x,
            model.max.y - model.min.y,
            model.max.z - model.min.z,
          ].reduce((a, b) => a > b ? a : b);

      expect(bottom, closeTo(0, 0.0001), reason: model.name);
      expect(longest, closeTo(model.targetLongestMetres, 0.001), reason: model.name);
      expect(model.androidMetres, model.targetLongestMetres);
      expect(model.placementTransform(ios: false).entry(0, 0), model.androidMetres);
    }
  });

  test('the table stands 0.75 m tall and stays on the floor when turned', () {
    final table = FurnitureArCatalog.table;
    final height =
        table.iosScaleVector.y * 0.01 * (table.max.y - table.min.y);
    expect(height, closeTo(0.75, 0.001));
    expect(table.androidHeightScale * 1.52, closeTo(0.75, 0.01));
    final androidPose = table.pose(
      ios: false,
      pitch: 0,
      yaw: 0,
      roll: 0,
      slideX: 0,
      slideZ: 0,
    );
    expect(
      table.min.y * table.androidHeightScale + androidPose.getTranslation().y,
      closeTo(0, 0.001),
    );

    final bottom = Vector3(0, table.fileTranslationY + 0.01 * table.min.y, 0);
    for (final turn in [0.0, 1.2, -0.8]) {
      for (final axis in [0, 1, 2]) {
        final pose = table.pose(
          ios: true,
          pitch: axis == 0 ? turn : 0,
          yaw: axis == 1 ? turn : 0,
          roll: axis == 2 ? turn : 0,
          slideX: 0.3,
          slideZ: -0.2,
        );
        final planted = pose.transformed3(bottom);
        expect(planted.y, closeTo(0, 0.0001));
        expect(planted.x, closeTo(0.3, 0.0001));
        expect(planted.z, closeTo(-0.2, 0.0001));
      }
    }
  });

  test('the catalogue piece uses its own model', () {
    expect(FurnitureArCatalog.forHint('sofa').asset, endsWith('sofa.glb'));
    expect(FurnitureArCatalog.forHint('table').asset, endsWith('table.glb'));
    expect(FurnitureArCatalog.forHint('light').asset, endsWith('lamp.glb'));
    expect(FurnitureArCatalog.forHint('wardrobe').asset, endsWith('wardrobe.glb'));
    expect(FurnitureArCatalog.forHint('rug').asset, endsWith('rug.glb'));
    expect(FurnitureArCatalog.forHint('chair').asset, endsWith('armchair.glb'));
  });
}
