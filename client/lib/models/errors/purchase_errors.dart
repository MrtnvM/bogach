import 'package:in_app_purchase/in_app_purchase.dart';

class NoInAppPurchaseProductsError implements Exception {
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
