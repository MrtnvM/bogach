import 'package:cash_flow/services/dynamic_link/utils/dynamic_link_parameters.dart';
import 'package:cash_flow/utils/core/platform/package_info_utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/app_configuration.dart';

Future<String> getRoomInviteLink({
  @required String roomId,
  @required UserProfile currentUser,
}) async {
  final packageName = await getPackageName();

  final urlPrefix = '${AppConfiguration.environment.dynamicLink.baseUrl}'
      '${DynamicLinks.join}';

  final deepLink = '${AppConfiguration.environment.dynamicLink.baseUrl}'
      '?${DynamicLinks.roomInvite}=$roomId';
  final link = Uri.parse(deepLink);

  final socialMetaTagParameters = SocialMetaTagParameters(
    title: Strings.battleInvitationTitle,
    description:
        '${currentUser.fullName} ${Strings.battleInvitationDescription}',
  );

  final parameters = DynamicLinkParameters(
    uriPrefix: urlPrefix,
    link: link,
    androidParameters: getAndroidDynamicLinkParameters(packageName),
    iosParameters: getIosDynamicLinkParameters(packageName),
    googleAnalyticsParameters: null,
    // TODO(Maxim): Add info
    itunesConnectAnalyticsParameters: null,
    // TODO(Maxim): Add info
    socialMetaTagParameters: socialMetaTagParameters,
  );

  final shortLink = await parameters.buildShortLink();
  return shortLink.shortUrl.toString();
}
