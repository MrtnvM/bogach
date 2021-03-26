import 'dart:io';

import 'package:cash_flow/services/dynamic_link/utils/create_dynamic_link.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

Future<String> getAddFriendLink({@required UserProfile currentUser}) async {
  final dynamicLink = await createDynamicLink(
    queryParameters: {DynamicLinks.inviterId: currentUser.id},
    socialTagParameters: SocialMetaTagParameters(
      title: Strings.addFriendLinkTitle,
      description:
          '${currentUser.fullName} ${Strings.addFriendLinkDescription}',
    ),
    analyticsParameters: GoogleAnalyticsParameters(
      source: Platform.operatingSystem,
      campaign: 'friends-campaign',
      medium: 'none',
    ),
  );

  return dynamicLink;
}
