import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/mappers/new_game_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

class GameService {
  GameService({
    @required this.apiClient,
    @required this.firestore,
    @required this.firebaseDatabase,
  })  : assert(apiClient != null),
        assert(firestore != null),
        assert(firebaseDatabase != null);

  final CashFlowApiClient apiClient;
  final FirebaseFirestore firestore;
  final FirebaseDatabase firebaseDatabase;

  Future<List<GameTemplate>> getGameTemplates() {
    return apiClient.getGameTemplates().map(mapToGameTemplates).first;
  }

  Future<List<Quest>> getQuests(String userId) {
    return apiClient.getQuests(userId).first;
  }

  Future<String> createNewGame({
    @required String templateId,
    @required String userId,
  }) {
    return apiClient
        .createNewGame(templateId: templateId, userId: userId)
        .map((response) => response.id)
        .first;
  }

  Future<String> createQuestGame({
    @required String gameLevelId,
    @required String userId,
  }) {
    return apiClient
        .createNewQuestGame(questId: gameLevelId, userId: userId)
        .map((response) => response.id)
        .first;
  }

  Stream<Game> getGame(GameContext gameContext) {
    return firestore
        .collection('games')
        .doc(gameContext.gameId)
        .snapshots()
        .map((snapshot) => Game.fromJson(snapshot.data()));
  }

  Future<Game> getGameByLevel(String levelId, String userId) async {
    final gameDocs = await firestore
        .collection('games')
        .where('participants', arrayContains: userId)
        .where('config.level', isEqualTo: levelId)
        .get();

    final games = gameDocs.docs
        .map((d) => Game.fromJson(d.data()))
        .where((g) => g.state.gameStatus != GameStatus.gameOver)
        .toList();

    if (games.isEmpty) {
      return null;
    }

    return games.first;
  }

  Future<List<Game>> getUserGames(String userId) async {
    final gameDocs = await firestore
        .collection('games')
        .where('participants', arrayContains: userId)
        .where('config.level', isNull: true)
        .get();

    final games = gameDocs.docs
        .map((d) => Game.fromJson(d.data()))
        .where((g) => g.state.gameStatus != GameStatus.gameOver)
        .toList();

    games.sort((g1, g2) {
      final date1 = g1.updatedAt?.millisecondsSinceEpoch ?? 0;
      final date2 = g2.updatedAt?.millisecondsSinceEpoch ?? 0;
      return date2 - date1;
    });

    return games;
  }

  Future<void> sendPlayerAction(PlayerActionRequestModel playerAction) {
    return apiClient.sendPlayerAction(playerAction).first;
  }

  Future<void> startNewMonth(GameContext gameContext) {
    return apiClient.startNewMonth(gameContext).first;
  }

  Future<Room> createRoom(CreateRoomRequestModel requestModel) {
    return apiClient.createRoom(requestModel).first;
  }

  Future<void> setRoomParticipantReady(String roomId, String participantId) {
    return apiClient.setRoomParticipantReady(roomId, participantId).first;
  }

  Future<void> createRoomGame(String roomId) {
    return apiClient.createRoomGame(roomId).first;
  }

  Stream<Room> subscribeOnRoomUpdates(String roomId) {
    return firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) => Room.fromJson(snapshot.data()));
  }

  Future<Room> getRoom(String roomId) {
    return firestore
        .collection('rooms')
        .doc(roomId)
        .get()
        .then((snapshot) => Room.fromJson(snapshot.data()));
  }

  Future<void> shareRoomInviteLink({
    @required String roomId,
    @required UserProfile currentUser,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;

    final deepLink = '${DynamicLinks.baseUrl}'
        '${DynamicLinks.roomInvite}?'
        'room_id=$roomId';

    final parameters = DynamicLinkParameters(
      uriPrefix: '${DynamicLinks.baseUrl}join',
      link: Uri.parse(deepLink),
      androidParameters: AndroidParameters(
        packageName: packageName,
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: packageName,
        minimumVersion: '1.0.0',
        appStoreId: null, // TODO(Maxim): Add AppStore ID
      ),
      googleAnalyticsParameters: null, // TODO(Maxim): Add info
      itunesConnectAnalyticsParameters: null, // TODO(Maxim): Add info
      socialMetaTagParameters: SocialMetaTagParameters(
        title: Strings.battleInvitationTitle,
        description:
            '${currentUser.fullName} ${Strings.battleInvitationDescription}',
      ),
    );

    Logger.d(parameters);

    // final shortLink = await parameters.buildShortLink();
    // final dynamicLink = shortLink.shortUrl.toString();
    // logger.d('ROOM INVITE DYNAMIC LINK: $dynamicLink');
    // logger.d('ROOM INVITE DYNAMIC LINK WARNINGS:');
    // logger.d(shortLink.warnings.toList());

    Share.share(deepLink);
  }
}
