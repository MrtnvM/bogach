import 'package:cash_flow/services/dynamic_link/utils/dynamic_link_parameters.dart';
import 'package:cash_flow/utils/core/platform/package_info_utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/app_configuration.dart';

Future<String> getAddFriendLink({
  @required String roomId,
  @required UserProfile currentUser,
}) async {
  final packageName = await getPackageName();

  final linkPrefix = '${AppConfiguration.environment.dynamicLink.baseUrl}'
      '${DynamicLinks.join}';

  final deepLink = '${AppConfiguration.environment.dynamicLink.baseUrl}'
      '?${DynamicLinks.addFriend}=${currentUser.id}';
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
    androidParameters: getAndroidParameters(packageName),
    iosParameters: getIosParameters(packageName),
    googleAnalyticsParameters: null,
    // TODO(Maxim): Add info
    itunesConnectAnalyticsParameters: null,
    // TODO(Maxim): Add info
    socialMetaTagParameters: socialMetaTagParameters,
  );

  final shortLink = await parameters.buildShortLink();
  return shortLink.shortUrl.toString();
}
