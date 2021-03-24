import 'dart:io';

import 'package:cash_flow/services/dynamic_link/utils/create_dynamic_link.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

Future<String> getRoomInviteLink({
  @required String roomId,
  @required UserProfile currentUser,
}) async {
  final dynamicLink = await createDynamicLink(
    queryParameters: {DynamicLinks.roomInvite: roomId},
    socialTagParameters: SocialMetaTagParameters(
      title: Strings.battleInvitationTitle,
      description:
          '${currentUser.fullName} ${Strings.battleInvitationDescription}',
    ),
    analyticsParameters: GoogleAnalyticsParameters(
      campaign: 'room-invite',
      source: Platform.operatingSystem,
      medium: 'none',
    ),
  );

  return dynamicLink;
}
