import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

// ignore: avoid_classes_with_only_static_members
class SessionTracker {
  static bool isLoggingEnabled = !kReleaseMode;

  static final onboarding = _TraceHolder('onboarding');
  static final gameLaunched = _TraceHolder('game_launched');

  static final quest = _TraceHolder('quest');
  static final singleplayerGame = _TraceHolder('singleplayer_game');
  static final multiplayerGame = _TraceHolder('multiplayer_game');

  static final multiplayerGameCreated =
      _TraceHolder('multiplayer_game_created');
  static final multiplayerGameJoined = //
      _TraceHolder('multiplayer_game_joined');
}

class _TraceHolder {
  _TraceHolder(this.key);

  final String key;

  Trace _trace;

  void start() {
    if (SessionTracker.isLoggingEnabled) {
      print('TRACKING (start): $key');
    }

    FirebasePerformance.startTrace(key).then((trace) {
      _trace = trace;
    });
  }

  void stop() {
    if (SessionTracker.isLoggingEnabled) {
      print('TRACKING (end): $key');
    }

    _trace?.stop();
  }

  bool get isStarted => _trace != null;

  void getMetric(String name) => _trace?.getMetric(name);
  void setMetric(String name, int value) => _trace?.setMetric(name, value);

  void incrementMetric(String name, int value) =>
      _trace?.incrementMetric(name, value);

  void getAttribute(String name) => //
      _trace?.getAttribute(name);

  void setAttribute(String name, String value) =>
      _trace?.putAttribute(name, value);

  void removeAttribute(String name) => //
      _trace?.removeAttribute(name);
}
