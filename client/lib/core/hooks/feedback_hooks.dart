import 'dart:convert';
import 'dart:typed_data';

import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/widgets/utils/better_feedback/better_feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Game _currentGame;
String _userId;

_FeedbackSender useFeedbackSender() {
  final context = useContext();

  return _FeedbackSender(
    showFeedbackPage: (game, userId) {
      _currentGame = game;
      _userId = userId;

      BetterFeedback.of(context).show();
    },
    sendFeedback: _sendFeedback,
  );
}

class _FeedbackSender {
  _FeedbackSender({
    @required this.showFeedbackPage,
    @required this.sendFeedback,
  });

  final void Function(Game game, String userId) showFeedbackPage;
  final void Function(
    BuildContext context,
    String whatsWrong,
    Uint8List image,
  ) sendFeedback;
}

Future<void> _sendFeedback(
  BuildContext context,
  String whatsWrong,
  Uint8List image,
) async {
  try {
    final date = DateTime.now();
    final timestamp = date.millisecondsSinceEpoch;
    const collection = 'feedback';
    final child = '$timestamp';

    final imageUrl = await FirebaseStorage.instance
        .ref()
        .child(collection)
        .child('$child.png')
        .putData(image)
        .then((value) => value.ref.getDownloadURL());

    await FirebaseFirestore.instance.collection(collection).doc(child).set({
      'id': timestamp,
      'userId': _userId,
      'whatsWrong': whatsWrong,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'game': json.encode(_currentGame.toJson()),
    });

    BetterFeedback.of(context).hide();
  } catch (error) {
    handleError(
      context: context,
      exception: error,
      onRetry: () {
        _sendFeedback(context, whatsWrong, image);
      },
      onCancel: () => BetterFeedback.of(context).hide(),
    );
  }
}
