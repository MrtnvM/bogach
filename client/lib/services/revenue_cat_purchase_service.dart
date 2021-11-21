import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/user/purchase_profile.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/models/network/request/purchases/purchase_details_request_model.dart';
import 'package:cash_flow/models/network/request/purchases/update_purchases_request_model.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatPurchaseService {
  RevenueCatPurchaseService({required this.apiClient});

  CashFlowApiClient apiClient;

  Future<void> login(String userId) async {
    final result = await Purchases.logIn(userId);
    print('RC LOGIN: $result');
  }

  Future<void> logout() async {
    final result = await Purchases.logOut();
    print('RC LOGOUT: $result');
  }

  Future<PurchaseProfile> purchase(String productId) async {
    try {
      await Purchases.purchaseProduct(productId);
      final purchaseProfile = await _updatePurchaseProfile([productId]);
      return purchaseProfile;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        throw PurchaseCanceledException(productId, e);
      }

      rethrow;
    }
  }

  Future<PurchaseProfile> restorePurchases() async {
    final purchaserInfo = await Purchases.restoreTransactions();
    final purchases = purchaserInfo.nonSubscriptionTransactions;
    final purchasedProductIds = purchases.map((p) => p.productId).toList();

    final purchaseProfile = await _updatePurchaseProfile(purchasedProductIds);
    return purchaseProfile;
  }

  Future<PurchaseProfile> _updatePurchaseProfile(
    List<String> productsIds,
  ) async {
    final userId = await Purchases.appUserID;
    final purchaseRequest = UpdatePurchasesRequestModel(
      userId: userId,
      purchases: [
        for (final productId in productsIds)
          PurchaseDetailsRequestModel(
            productId: productId,
            purchaseId: productId,
          )
      ],
    );

    final purchaseProfile = await apiClient
        .sendPurchasedProducts(purchaseRequest)
        .onError(recordError);

    return purchaseProfile;
  }
}
