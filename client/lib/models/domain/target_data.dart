import 'package:cash_flow/models/network/responses/target_type.dart';
import 'package:flutter/material.dart';

class TargetData {
  const TargetData({
    @required this.value,
    @required this.type,
  })  : assert(value != null),
        assert(type != null);

  final int value;
  final TargetType type;
}
