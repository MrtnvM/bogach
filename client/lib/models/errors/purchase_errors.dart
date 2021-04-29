import 'package:in_app_purchase/in_app_purchase.dart';

class ProductPurchaseFailedException implements Exception {
  ProductPurchaseFailedException(this.product);

  final ProductDetails product;

  @override
  String toString() {
    return product.productDescription;
  }
}

class ProductPurchaseCanceledException implements Exception {
  const ProductPurchaseCanceledException(this.product);

  final ProductDetails product;

  @override
  String toString() {
    return product.productDescription;
  }
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

  final IAPError? error;

  @override
  String toString() {
    return 'Source: ${error?.source.runtimeType.toString()}\n'
        'Code: ${error?.code}'
        'Message: ${error?.message}'
        'Details: ${error?.details?.toString()}';
  }
}

extension ProductDetailsExtension on ProductDetails {
  String get productDescription {
    final detail = skProduct?.productIdentifier ?? skuDetail?.sku ?? '';
    return 'Product ID: $id\n'
        'Product Details: $detail\n';
  }
}
