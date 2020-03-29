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
