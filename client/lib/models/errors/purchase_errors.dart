import 'package:in_app_purchase/in_app_purchase.dart';

class ProductPurchaseFailedException implements Exception {
  ProductPurchaseFailedException(this.product);

  final ProductDetails product;
}

class ProductPurchaseCanceledException implements Exception {
  const ProductPurchaseCanceledException(this.product);

  final ProductDetails product;
}

class NoInAppPurchaseProductsException implements Exception {
  NoInAppPurchaseProductsException(this.notFoundIds);

  final List<String> notFoundIds;

  @override
  String toString() {
    return 'The following ids weren\'t found $notFoundIds';
  }
}

class QueryPastPurchasesRequestException implements Exception {
  QueryPastPurchasesRequestException(this.error);

  final IAPError error;
}
