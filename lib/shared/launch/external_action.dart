import 'package:url_launcher/url_launcher.dart';

Future<bool> openExternalUri(Uri uri) async {
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<bool> callPhoneNumber(String e164) {
  return openExternalUri(Uri(scheme: 'tel', path: e164));
}

Future<bool> emailAddress(String address) {
  return openExternalUri(Uri(scheme: 'mailto', path: address));
}

Future<bool> openWebsite(String url) {
  return openExternalUri(Uri.parse(url));
}
