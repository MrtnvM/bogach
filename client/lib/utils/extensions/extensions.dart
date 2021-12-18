import 'package:intl/intl.dart';

final _defaultCurrencyFormat = NumberFormat.currency(
  decimalDigits: 0,
  symbol: '₽',
);

extension PriceFormatting on num {
  String toPrice() {
    return _defaultCurrencyFormat.format(this);
  }

  String toPriceWithoutSymbol() {
    return _defaultCurrencyFormat.format(this).replaceAll('₽', '').trim();
  }

  String toPriceWithSign() {
    final price = toPrice();
    return this > 0 ? '+$price' : price;
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
