import 'dart:convert';

import 'package:crypto/crypto.dart';

const questsAccessProductId = 'bogach.quests.access';
const multiplayer1ProductId = 'bogach.multiplayer.games.1';
const multiplayer10ProductId = 'bogach.multiplayer.games.10';
const multiplayer25ProductId = 'bogach.multiplayer.games.25';
const newYear2022ActionProductId = 'bogach.new_year_2022';

String hashProductId(String productId) {
  const salt = '(c) Bogach Team';
  final string = productId + salt;
  final bytes = utf8.encode(string);

  final hash1 = sha256.convert(bytes).toString();
  final hash2 = sha256.convert(utf8.encode(hash1)).toString();
  final hash3 = sha256.convert(utf8.encode(hash2)).toString();

  return hash3;
}

enum MultiplayerGamePurchases {
  oneGame,
  tenGames,
  twentyFiveGames,
}

extension MultiplayerGamePurchasesExtension on MultiplayerGamePurchases {
  String get productId {
    switch (this) {
      case MultiplayerGamePurchases.oneGame:
        return multiplayer1ProductId;

      case MultiplayerGamePurchases.tenGames:
        return multiplayer10ProductId;

      case MultiplayerGamePurchases.twentyFiveGames:
        return multiplayer25ProductId;

      default:
        return '';
    }
  }
}
