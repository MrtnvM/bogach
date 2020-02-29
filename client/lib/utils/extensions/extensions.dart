import 'package:intl/intl.dart';

extension PriceFormatting on num {
  String toPrice() {
    final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0);

    return formatCurrency.format(this);
  }

  String toPercent() {
    return '$this%';
  }
}
