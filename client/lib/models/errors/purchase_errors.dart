class PurchaseCanceledException implements Exception {
  const PurchaseCanceledException(this.productId, [this.error]);

  final String productId;
  final dynamic error;

  @override
  String toString() {
    return '$runtimeType: $productId';
  }
}
