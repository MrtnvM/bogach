import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:intl/intl.dart';

extension PriceFormatting on num {
  String toPrice() {
    final formatCurrency = NumberFormat.currency(decimalDigits: 0, symbol: '₽');

    return formatCurrency.format(this);
  }

  String toPercent() {
    return '$this%';
  }
}

extension RequestStateHelper on AsyncAction {
  RequestState get requestState {
    if (isStarted) {
      return RequestState.inProgress;
    } else if (isSucceed) {
      return RequestState.success;
    } else if (isFailed) {
      return RequestState.error;
    } else {
      return RequestState.idle;
    }
  }

  RefreshableRequestState mapToRefreshableRequestState({bool isRefreshing}) {
    if (isStarted) {
      if (isRefreshing == true) {
        return RefreshableRequestState.refreshing;
      }

      return RefreshableRequestState.inProgress;
    } else if (isSucceed) {
      return RefreshableRequestState.success;
    } else if (isFailed) {
      return RefreshableRequestState.error;
    } else {
      return RefreshableRequestState.idle;
    }
  }
}
