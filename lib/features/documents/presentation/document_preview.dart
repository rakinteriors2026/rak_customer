/// Preview photo for a published project file. The file itself stays a
/// document; the picture is the room it belongs to.
String documentPreviewAsset({String? type, String? assetId, String? title}) {
  final key = '${type ?? ''} ${assetId ?? ''} ${title ?? ''}'.toLowerCase();
  if (key.contains('invoice')) return 'assets/photos/oak_laminate.png';
  if (key.contains('quot')) return 'assets/photos/living_room_design.png';
  if (key.contains('agree') || key.contains('contract')) {
    return 'assets/photos/courtyard_home.png';
  }
  return 'assets/photos/hero_home.png';
}
