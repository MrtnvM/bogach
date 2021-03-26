import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_state.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';

T useConfig<T>(T Function(ConfigState) converter) {
  return useGlobalState((s) => converter(s.config));
}

_OnlineStatus useOnlineStatus() {
  final isOnline = useConfig((c) => c.isOnline ?? true);

  final statusColor = isOnline //
      ? ColorRes.onlineStatus
      : ColorRes.offlineStatus;

  final description = isOnline //
      ? Strings.online
      : Strings.offline;

  return _OnlineStatus(
    isOnline: isOnline,
    color: statusColor,
    description: description,
  );
}

class _OnlineStatus {
  const _OnlineStatus({this.isOnline, this.color, this.description});

  final bool isOnline;
  final Color color;
  final String description;
}
