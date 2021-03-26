import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:share/share.dart';

Future<void> shareDynamicLink(String dynamicLink) async {
  Logger.i('Share dymanic link: $dynamicLink');
  return Share.share(dynamicLink);
}
