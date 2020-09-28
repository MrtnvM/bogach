import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/features/purchase/actions/buy_actions.dart';
import 'package:cash_flow/features/purchase/actions/query_past_purchases_action.dart';
import 'package:cash_flow/features/purchase/actions/query_products_for_sale_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_core/dash_kit_core.dart' hide StoreProvider;
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:async_redux/async_redux.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage();

  @override
  State<StatefulWidget> createState() {
    return _PurchaseListPageState();
  }
}

class _PurchaseListPageState extends State<PurchaseListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CashAppBar.withBackButton(title: Strings.purchases),
      body: AppStateConnector<RequestState>(
        onInit: (s) {
          StoreProvider.dispatch(context, QueryPastPurchasesAction());
        },
        converter: (s) {
          return s.network.getRequestState(NetworkRequest.queryPastPurchases);
        },
        builder: (context, requestState) => LoadableView(
          isLoading: requestState.isInProgress,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return AppStateConnector<BuiltList<PurchaseDetails>>(
      converter: (s) => s.purchase.pastPurchases,
      builder: (context, pastPurchases) => ListView(
        children: [
          const Text('Past purchases', style: Styles.navBarTitle),
          ...pastPurchases.map(_buildItem).toList(),
          const Divider(),
          const Text('Possible purchases', style: Styles.navBarTitle),
          ...buildPossiblePurchases([
            'test_subscription_1_month',
            'android.test.purchased',
            'test_consumable',
          ]),
        ],
      ),
    );
  }

  Widget _buildItem(PurchaseDetails item) {
    return ListTile(
      title: Text(item.productID),
      subtitle: Text(item.getDescription()),
    );
  }

  void _purchaseItem(String productId) {
    final dispatch = (action) => StoreProvider.dispatchFuture(context, action);

    dispatch(QueryProductsForSaleAction(ids: {productId})).then((_) {
      final appState = StoreProvider.state<AppState>(context);
      final productsForSale = appState.purchase.productsForSale;

      final product = productsForSale.firstWhere(
        (p) => p.id == productId,
        orElse: () => null,
      );

      dispatch(BuyConsumableAction(product: product));
    }).catchError((error) {
      handleError(context: context, exception: error);
    });
  }

  List<Widget> buildPossiblePurchases(List<String> list) {
    return list
        .map((e) => ListTile(title: Text(e), onTap: () => _purchaseItem(e)))
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
