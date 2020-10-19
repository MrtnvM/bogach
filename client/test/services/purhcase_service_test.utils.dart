import 'package:in_app_purchase/in_app_purchase.dart';

import '../mocks/fake_purchase_details.dart';

PurchaseDetails createPurchase(
  int id,
  PurchaseStatus status, {
  bool pendingComplete = false,
}) {
  return FakePurchaseDetails(
    productId: 'product$id',
    purchaseId: 'purhcase$id',
    status: status,
    pendingComplete: pendingComplete,
  );
}

ProductDetails createProduct(int id, [int price = 149]) {
  return ProductDetails(
    id: 'product$id',
    title: 'Product #1',
    description: 'Product #$id description',
    price: price.toString(),
  );
}
