import 'package:url_launcher/url_launcher.dart';

void cliqueDotCode() async {
  const String url = 'https://www.youtube.com/@DotcodeEdu';

  Uri uri = Uri.parse(url);

  await launchUrl(uri, mode: LaunchMode.inAppWebView);
}
