import 'package:flutter/material.dart';

class GameboardMenuController extends Listenable {
  final _listeners = <VoidCallback>[];
  var _isShown = false;

  bool get isShown => _isShown;

  void show() {
    if (!_isShown) {
      _isShown = true;
      _notifyListeners();
    }
  }

  void close() {
    if (_isShown) {
      _isShown = false;
      _notifyListeners();
    }
  }

  @override
  void addListener(void Function() listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}
