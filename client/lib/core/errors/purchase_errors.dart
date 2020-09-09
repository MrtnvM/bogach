import 'package:in_app_purchase/in_app_purchase.dart';

class NoInAppPurchaseProductsError extends Error {}

class QueryPastPurchasesRequestError extends Error {
  QueryPastPurchasesRequestError(this.error);

  final IAPError error;
}
