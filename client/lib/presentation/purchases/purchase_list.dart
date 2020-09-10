import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/features/purchase/purchase_state.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage();

  @override
  State<StatefulWidget> createState() {
    return _PurchaseListPageState();
  }
}

class _PurchaseListPageState extends State<PurchaseListPage> with ReduxState {
  @override
  void initState() {
    super.initState();

    dispatchAsyncAction(QueryPastPurchasesAsyncAction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CashAppBar.withBackButton(title: Strings.purchases),
      body: AppStateConnector<PurchaseState>(
        converter: (s) => s.purchase,
        builder: (context, state) => Loadable(
          isLoading: state.getPastPurchasesRequestState.isInProgress,
          child: _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildBody(PurchaseState state) {
    return ListView(
      children: [
        const Text('Past purchases', style: Styles.navBarTitle),
        ...state.pastPurchases.map(_buildItem).toList(),
        const Divider(),
        const Text('Possible purchases', style: Styles.navBarTitle),
        ...buildPossiblePurchases([
          'test_subscription_1_month',
          'android.test.purchased',
          'test_consumable',
        ]),
      ],
    );
  }

  Widget _buildItem(PurchaseDetails item) {
    return ListTile(
      title: Text(item.productID),
      subtitle: Text(item.getDescription()),
    );
  }

  void _onItemPressed(String productId) {
    dispatchAsyncAction(IsPurchasesAvailableAsyncAction())
        .listen((action) => action
          ..onSuccess((isAvailable) => _onPurchaseAvailableSuccess(
                productId: productId,
                isAvailable: isAvailable,
              ))
          ..onError((error) => _onPurchaseAvailableError(error: error)));
  }

  void _onPurchaseAvailableSuccess({
    @required String productId,
    @required bool isAvailable,
  }) {
    if (isAvailable) {
      _purchaseItem(productId);
    } else {
      showErrorDialog(context: context, message: Strings.storesUnavailable);
    }
  }

  void _onPurchaseAvailableError({dynamic error}) {
    handleError(context: context, exception: error);
  }

  void _purchaseItem(String productId) {
    // Buy same product again
    dispatchAsyncAction(QueryProductsForSaleAsyncAction(ids: {productId}))
        .listen((action) => action
          ..onSuccess(_onSuccessQueryProducts)
          ..onError(_onErrorQueryProducts));
  }

  void _onSuccessQueryProducts(BuiltList<ProductDetails> products) {
    dispatchAsyncAction(BuyConsumableAsyncAction(product: products.first));
  }

  void _onErrorQueryProducts(dynamic error) {
    handleError(context: context, exception: error);
  }

  List<Widget> buildPossiblePurchases(List<String> list) {
    return list
        .map((e) => ListTile(
              title: Text(e),
              onTap: () => _purchaseItem(e),
            ))
        .toList();
  }
}

extension PurchaseDetailsExtension on PurchaseDetails {
  String getDescription() {
    final transactionDateString =
        DateTime.fromMillisecondsSinceEpoch(int.parse(transactionDate))
            .toIso8601String();
    final statusString = status.toString();
    final platformString = platform.name;

    return '$transactionDateString\n$statusString\n$platformString\n';
  }

  InAppPlatform get platform {
    if (skPaymentTransaction == null) {
      return InAppPlatform.android;
    }

    if (billingClientPurchase == null) {
      return InAppPlatform.ios;
    }

    throw Exception('Unknown platform exception');
  }
}

enum InAppPlatform { ios, android }

extension InAppPlatformExtension on InAppPlatform {
  String get name {
    switch (this) {
      case InAppPlatform.ios:
        return 'ios';
      case InAppPlatform.android:
        return 'android';
      default:
        return '';
    }
  }
}
