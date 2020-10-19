import 'package:in_app_purchase/in_app_purchase.dart';

class ProductPurchaseFailedError extends Error {
  ProductPurchaseFailedError(this.product);

  final ProductDetails product;
}

class NoInAppPurchaseProductsError extends Error {
  NoInAppPurchaseProductsError(this.notFoundIds);

  final List<String> notFoundIds;

  @override
  String toString() {
    return 'The following ids weren\'t found $notFoundIds';
  }
}

class QueryPastPurchasesRequestError extends Error {
  QueryPastPurchasesRequestError(this.error);

  final IAPError error;
}
