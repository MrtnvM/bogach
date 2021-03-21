import 'package:cash_flow/services/dynamic_link/utils/dynamic_link_parameters.dart';
import 'package:cash_flow/utils/core/platform/package_info_utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/app_configuration.dart';

Future<String> getAddFriendLink({@required UserProfile currentUser}) async {
  final packageName = await getPackageName();

  final baseUrl = AppConfiguration.environment.dynamicLink.baseUrl;
  final deepLink = '$baseUrl?${DynamicLinks.inviterId}=${currentUser.id}';
  final link = Uri.parse(deepLink);

  final socialMetaTagParameters = SocialMetaTagParameters(
    title: Strings.addFriendLinkTitle,
    description: '${currentUser.fullName} ${Strings.addFriendLinkDescription}',
  );

  final parameters = DynamicLinkParameters(
    uriPrefix: baseUrl,
    link: link,
    androidParameters: getAndroidDynamicLinkParameters(packageName),
    iosParameters: getIosDynamicLinkParameters(packageName),
    googleAnalyticsParameters: GoogleAnalyticsParameters(
      source: 'app',
      campaign: 'friends-campaign',
      medium: 'none',
    ),
    // TODO(Maxim): Add info
    itunesConnectAnalyticsParameters: null,
    socialMetaTagParameters: socialMetaTagParameters,
  );

  final shortLink = await parameters.buildShortLink();
  return shortLink.shortUrl.toString();
}
