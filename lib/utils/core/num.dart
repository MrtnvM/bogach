extension DoubleExtensions on double {
  String toPrettyFormat() {
    final str = toStringAsFixed(
      truncateToDouble() == this ? 0 : 2,
    );

    if (str == '0') {
      return '0';
    }

    if (str.endsWith('.00')) {
      return str.substring(0, str.length - 3);
    }

    if (str.endsWith('.0')) {
      return str.substring(0, str.length - 2);
    }

    if (str.endsWith('0')) {
      return str.substring(0, str.length - 1);
    }

    return str;
  }
}
