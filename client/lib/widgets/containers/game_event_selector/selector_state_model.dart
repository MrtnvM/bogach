import 'package:flutter/material.dart';

class SelectorStateModel {
  const SelectorStateModel({
    @required this.availableCount,
    @required this.selectedCount,
    @required this.maxCount,
    @required this.minCount,
  });

  final int availableCount;
  final int selectedCount;
  final int maxCount;
  final int minCount;
}
