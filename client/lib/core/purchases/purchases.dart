import 'dart:convert';

import 'package:cash_flow/resources/strings.dart';
import 'package:crypto/crypto.dart';

const questsAccessProductId = 'bogach.quests.access';
const multiplayer1ProductId = 'bogach.multiplayer.1';
const multiplayer5ProductId = 'bogach.multiplayer.5';
const multiplayer10ProductId = 'bogach.multiplayer.10';

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
  fiveGames,
  tenGames,
}

extension MultiplayerGamePurchasesExtension on MultiplayerGamePurchases {
  String get title {
    switch (this) {
      case MultiplayerGamePurchases.oneGame:
        return Strings.purchase1Game;
      case MultiplayerGamePurchases.fiveGames:
        return Strings.purchase5Game;
      case MultiplayerGamePurchases.tenGames:
        return Strings.purchase10Game;
      default:
        return '';
    }
  }

  String get productId {
    switch (this) {
      case MultiplayerGamePurchases.oneGame:
        return multiplayer1ProductId;
      case MultiplayerGamePurchases.fiveGames:
        return multiplayer5ProductId;
      case MultiplayerGamePurchases.tenGames:
        return multiplayer10ProductId;
      default:
        return '';
    }
  }
}
