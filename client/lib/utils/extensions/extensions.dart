import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:intl/intl.dart';

extension PriceFormatting on num {
  String toPrice() {
    final formatCurrency = NumberFormat.currency(decimalDigits: 0, symbol: '₽');

    return formatCurrency.format(this);
  }

  String toPercent() {
    if (isInfinite || isNaN) {
      return '-';
    }

    final formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;

    return '${formatter.format(this)}%';
  }

  String toPercentWithSign() {
    if (isInfinite || isNaN) {
      return '-';
    }

    final value = toPercent();

    if (this > 0) {
      return '+$value';
    }

    if (this < 0) {
      return '$value';
    }

    return value;
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
