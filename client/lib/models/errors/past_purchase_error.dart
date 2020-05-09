class PastPurchaseError implements Exception {
  PastPurchaseError(this.code);

  final String code;

  @override
  String toString() {
    return 'The error with code: $code has occured';
  }
}
