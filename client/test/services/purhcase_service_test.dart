import 'dart:async';

import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/models/domain/user/purchase_profile.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/models/network/request/purchases/purchase_details_request_model.dart';
import 'package:cash_flow/models/network/request/purchases/update_purchases_request_model.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../mocks/fake_purchase_details.dart';
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

  test('Successful restoring past purchases', () async {
    const userId = 'user1';
    final purchase1 = createPurchase(1, PurchaseStatus.purchased);
    final purchase2 = createPurchase(
      2,
      PurchaseStatus.purchased,
      pendingComplete: true,
    );

    when(mockConnection.purchaseUpdatedStream).thenAnswer((_) {
      return Stream.value([]);
    });

    when(mockConnection.queryPastPurchases()).thenAnswer((_) async {
      return QueryPurchaseDetailsResponse(
        pastPurchases: [purchase1, purchase2],
      );
    });

    when(mockConnection.completePurchase(purchase2)).thenAnswer((_) async {
      return BillingResultWrapper(responseCode: BillingResponse.ok);
    });

    final purchaseProfile = PurchaseProfile(
      isQuestsAvailable: true,
      multiplayerGamesCount: 3,
    );

    final updatePurchaseRequestModel = UpdatePurchasesRequestModel(
      userId: userId,
      purchases: [
        PurchaseDetailsRequestModel.fromPurchase(purchase1),
        PurchaseDetailsRequestModel.fromPurchase(purchase2),
      ],
    );

    when(mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel))
        .thenAnswer((_) async => purchaseProfile);

    await purchaseService.startListeningPurchaseUpdates();

    final profile = await purchaseService.restorePastPurchases(userId);

    expect(profile, purchaseProfile);

    verifyInOrder([
      mockConnection.purchaseUpdatedStream,
      mockConnection.queryPastPurchases(),
      mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel),
      mockConnection.completePurchase(purchase2),
    ]);

    verifyNoMoreInteractions(mockConnection);
    verifyNoMoreInteractions(mockApiClient);
  });

  test('Successful buying of non consumable product', () async {
    const userId = 'user1';
    final product1 = createProduct(1);
    final purchase1 = createPurchase(
      1,
      PurchaseStatus.purchased,
      pendingComplete: true,
    );

    final purchases = BehaviorSubject<List<PurchaseDetails>>.seeded([]);

    when(mockConnection.purchaseUpdatedStream).thenAnswer((_) {
      return purchases;
    });

    when(mockConnection.queryPastPurchases()).thenAnswer((_) async {
      return QueryPurchaseDetailsResponse(pastPurchases: []);
    });

    when(mockConnection.queryProductDetails({product1.id})).thenAnswer(
      (_) async => ProductDetailsResponse(
        productDetails: [product1],
        notFoundIDs: [],
      ),
    );

    final purchaseProfile = PurchaseProfile(
      isQuestsAvailable: true,
      multiplayerGamesCount: 3,
    );

    final updatePurchaseRequestModel = UpdatePurchasesRequestModel(
      userId: userId,
      purchases: [
        PurchaseDetailsRequestModel.fromPurchase(purchase1),
      ],
    );

    when(
      mockConnection.buyNonConsumable(purchaseParam: anyNamed('purchaseParam')),
    ).thenAnswer((_) {
      purchases.value = [purchase1];
      return Future.value(true);
    });

    when(mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel))
        .thenAnswer((_) async => purchaseProfile);

    when(mockConnection.completePurchase(purchase1)).thenAnswer((_) async {
      return BillingResultWrapper(responseCode: BillingResponse.ok);
    });

    await purchaseService.startListeningPurchaseUpdates();

    final profile = await purchaseService.buyNonConsumableProduct(
      productId: product1.id,
      userId: userId,
    );

    expect(profile, purchaseProfile);

    verifyInOrder([
      mockConnection.purchaseUpdatedStream,
      mockConnection.queryProductDetails({product1.id}),
      mockConnection.buyNonConsumable(
        purchaseParam: anyNamed('purchaseParam'),
      ),
      mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel),
      mockConnection.completePurchase(purchase1),
    ]);

    verifyNoMoreInteractions(mockConnection);
    verifyNoMoreInteractions(mockApiClient);
  });

  test('Successful buying of consumable product', () async {
    const userId = 'user1';
    final product1 = createProduct(1);
    final purchase1 = createPurchase(
      1,
      PurchaseStatus.purchased,
      pendingComplete: true,
    );
    final purchases = BehaviorSubject<List<PurchaseDetails>>.seeded([]);

    when(mockConnection.purchaseUpdatedStream).thenAnswer((_) {
      return purchases;
    });

    when(mockConnection.queryProductDetails({product1.id})).thenAnswer(
      (_) async => ProductDetailsResponse(
        productDetails: [product1],
        notFoundIDs: [],
      ),
    );

    when(
      mockConnection.buyConsumable(purchaseParam: anyNamed('purchaseParam')),
    ).thenAnswer((_) {
      purchases.value = [purchase1];
      return Future.value(true);
    });

    final purchaseProfile = PurchaseProfile(
      isQuestsAvailable: true,
      multiplayerGamesCount: 3,
    );

    final updatePurchaseRequestModel = UpdatePurchasesRequestModel(
      userId: userId,
      purchases: [
        PurchaseDetailsRequestModel.fromPurchase(purchase1),
      ],
    );

    when(mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel))
        .thenAnswer((_) async => purchaseProfile);

    when(mockConnection.completePurchase(purchase1)).thenAnswer((_) async {
      return BillingResultWrapper(responseCode: BillingResponse.ok);
    });

    await purchaseService.startListeningPurchaseUpdates();

    final profile = await purchaseService.buyConsumableProduct(
      productId: product1.id,
      userId: userId,
    );

    expect(profile, purchaseProfile);

    verifyInOrder([
      mockConnection.purchaseUpdatedStream,
      mockConnection.queryProductDetails({product1.id}),
      mockConnection.buyConsumable(purchaseParam: anyNamed('purchaseParam')),
      mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel),
      mockConnection.completePurchase(purchase1),
    ]);

    verifyNoMoreInteractions(mockConnection);
    verifyNoMoreInteractions(mockApiClient);
  });

  test('Successfully restored bought quests access', () async {
    const userId = 'user1';
    final purchase = FakePurchaseDetails(
      purchaseId: 'purchase1',
      productId: questsAccessProductId,
      status: PurchaseStatus.purchased,
    );

    final purchases = BehaviorSubject<List<PurchaseDetails>>.seeded([]);

    when(mockConnection.purchaseUpdatedStream).thenAnswer((_) {
      return purchases;
    });

    when(mockConnection.queryPastPurchases()).thenAnswer((_) async {
      return QueryPurchaseDetailsResponse(pastPurchases: [purchase]);
    });

    final purchaseProfile = PurchaseProfile(
      isQuestsAvailable: true,
      multiplayerGamesCount: 3,
    );

    final updatePurchaseRequestModel = UpdatePurchasesRequestModel(
      userId: userId,
      purchases: [PurchaseDetailsRequestModel.fromPurchase(purchase)],
    );

    when(mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel))
        .thenAnswer((_) async => purchaseProfile);

    await purchaseService.startListeningPurchaseUpdates();

    final profile = await purchaseService.buyQuestsAcceess(userId);

    expect(profile, purchaseProfile);

    verifyInOrder([
      mockConnection.purchaseUpdatedStream,
      mockConnection.queryPastPurchases(),
      mockApiClient.sendPurchasedProducts(updatePurchaseRequestModel),
    ]);

    verifyNoMoreInteractions(mockConnection);
    verifyNoMoreInteractions(mockApiClient);
  });
}
