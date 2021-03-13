import 'package:cash_flow/services/dynamic_link/utils/dynamic_link_parameters.dart';
import 'package:cash_flow/utils/core/platform/package_info_utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/app_configuration.dart';

Future<String> getAddFriendLink({
  @required UserProfile currentUser,
}) async {
  final packageName = await getPackageName();

  final linkPrefix = '${AppConfiguration.environment.dynamicLink.baseUrl}'
      '${DynamicLinks.addFriend}';

  final deepLink = '${AppConfiguration.environment.dynamicLink.baseUrl}'
      '?${DynamicLinks.inviterId}=${currentUser.id}';
  final link = Uri.parse(deepLink);

  final linkDescription =
      '${currentUser.fullName} ${Strings.addFriendLinkDescription}';
  final socialMetaTagParameters = SocialMetaTagParameters(
    title: Strings.addFriendLinkTitle,
    description: linkDescription,
  );

  final parameters = DynamicLinkParameters(
    uriPrefix: linkPrefix,
    link: link,
    androidParameters: getAndroidDynamicLinkParameters(packageName),
    iosParameters: getIosDynamicLinkParameters(packageName),
    googleAnalyticsParameters: null,
    // TODO(Maxim): Add info
    itunesConnectAnalyticsParameters: null,
    // TODO(Maxim): Add info
    socialMetaTagParameters: socialMetaTagParameters,
  );

  var shortLink;
  try {
    shortLink = await parameters.buildShortLink();
  } catch (e) {
    print(e);
    const a = 2;
  }
  return shortLink.shortUrl.toString();
}
