/// Local stand-in for an approved drawing. The picture is the room
/// the drawing describes.
String designPreviewAsset({String? hint, String? title, String? assetId}) {
  final key = '${hint ?? ''} ${title ?? ''} ${assetId ?? ''}'.toLowerCase();
  if (key.contains('kitchen')) return 'assets/photos/courtyard_home.png';
  if (key.contains('living')) return 'assets/photos/living_room_design.png';
  if (key.contains('joinery')) return 'assets/photos/oak_laminate.png';
  return 'assets/photos/hero_home.png';
}
