import 'package:fimber/fimber.dart';
import 'package:share/share.dart';

Future<void> shareDynamicLink(String dynamicLink) async {
  Fimber.i('Share dymanic link: $dynamicLink');
  return Share.share(dynamicLink);
}
