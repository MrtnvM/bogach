import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_api_client.dart';
import '../mocks/mock_in_app_purchase_connection.dart';
import 'purhcase_service_test.utils.dart';

void main() {
  final mockApiClient = MockCashFlowApiClient();
  final mockConnection = MockInAppPurchaseConnection();
  PurchaseService purchaseService;

  setUp(() {
    reset(mockApiClient);
    reset(mockConnection);

    purchaseService = PurchaseService(
      apiClient: mockApiClient,
      connection: mockConnection,
    );
  });

  test('Empty purchase lists before start listening purchases', () async {
    final purchases = await purchaseService.purchases.first;
    expect(purchases, []);

    final pastPurchases = await purchaseService.pastPurchases.first;
    expect(pastPurchases, []);

    verifyZeroInteractions(mockConnection);
  });

  test('Not empty purchase lists after start listening purchases', () async {
    final purchase1 = createPurchase(1, PurchaseStatus.purchased);
    final purchase2 = createPurchase(2, PurchaseStatus.error);
    final purchase3 = createPurchase(3, PurchaseStatus.pending);
    final purchase4 = createPurchase(
      4,
      PurchaseStatus.purchased,
      pendingComplete: true,
    );

    when(mockConnection.purchaseUpdatedStream).thenAnswer(
      (_) => Stream.value([purchase1, purchase2, purchase3, purchase4]),
    );

    when(mockConnection.completePurchase(purchase4)).thenAnswer((_) async {
      return BillingResultWrapper(responseCode: BillingResponse.error);
    });

    await purchaseService.startListeningPurchaseUpdates();

    final purchases = await purchaseService.purchases.first;
    expect(purchases, [purchase1, purchase2, purchase3, purchase4]);

    final pastPurchases = await purchaseService.pastPurchases.first;
    expect(pastPurchases, []);

    verifyInOrder([
      mockConnection.purchaseUpdatedStream,
      mockConnection.completePurchase(purchase4),
    ]);
    verifyNoMoreInteractions(mockConnection);
  });

  test('Should complete pending purchases on start of listening', () async {
    final purchase1 = createPurchase(1, PurchaseStatus.purchased);
    final purchase2 = createPurchase(2, PurchaseStatus.error);
    final purchase3 = createPurchase(
      3,
      PurchaseStatus.error,
      pendingComplete: true,
    );

    when(mockConnection.purchaseUpdatedStream).thenAnswer(
      (_) => Stream.value([purchase1, purchase2, purchase3]),
    );

    when(mockConnection.completePurchase(purchase3)).thenAnswer((_) async {
      return BillingResultWrapper(responseCode: BillingResponse.ok);
    });

    await purchaseService.startListeningPurchaseUpdates();

    final purchases = await purchaseService.purchases.first;
    expect(purchases, [purchase1, purchase2, purchase3]);

    verifyInOrder([
      mockConnection.purchaseUpdatedStream,
      mockConnection.completePurchase(purchase3),
    ]);
    verifyNoMoreInteractions(mockConnection);
  });

  test('Getting Product Details', () async {
    final product = createProduct(1);

    when(mockConnection.queryProductDetails({product.id})).thenAnswer((_) {
      return Future.value(ProductDetailsResponse(
        notFoundIDs: [],
        productDetails: [product],
      ));
    });

    final recievedProduct = await purchaseService.getProduct(product.id);
    expect(recievedProduct, product);

    when(mockConnection.queryProductDetails({product.id})).thenAnswer((_) {
      return Future.value(ProductDetailsResponse(
        notFoundIDs: [product.id],
        productDetails: [],
      ));
    });

    expect(
      () => purchaseService.getProduct(product.id),
      throwsA(isInstanceOf<NoInAppPurchaseProductsError>()),
    );
  });

  test('Querying Past Purchases Details', () async {
    final purchase = createPurchase(1, PurchaseStatus.purchased);

    when(mockConnection.queryPastPurchases()).thenAnswer((_) {
      return Future.value(QueryPurchaseDetailsResponse(
        pastPurchases: [purchase],
        error: null,
      ));
    });

    final pastPurchases = await purchaseService.queryPastPurchases();
    expect(pastPurchases, [purchase]);

    when(mockConnection.queryPastPurchases()).thenAnswer((_) {
      return Future.value(QueryPurchaseDetailsResponse(
        pastPurchases: [],
        error: IAPError(message: '', source: IAPSource.AppStore, code: '0'),
      ));
    });

    expect(
      () => purchaseService.queryPastPurchases(),
      throwsA(isInstanceOf<QueryPastPurchasesRequestError>()),
    );
  });
}
