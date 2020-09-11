import 'dart:convert';

import 'package:crypto/crypto.dart';

const questsAccessProductId = 'bogach.quests.access';

String hashProductId(String productId) {
  const salt = '(c) Bogach Team';
  final string = productId + salt;
  final bytes = utf8.encode(string);

  final hash1 = sha256.convert(bytes).toString();
  final hash2 = sha256.convert(utf8.encode(hash1)).toString();
  final hash3 = sha256.convert(utf8.encode(hash2)).toString();

  return hash3;
}
