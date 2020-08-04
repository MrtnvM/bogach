import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/features/purchase/purchase_state.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseListPage extends StatefulWidget {
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
      children: state.pastPurchases.map(_buildItem).toList(),
    );
  }

  Widget _buildItem(PurchaseDetails item) {
    return InkWell(
      onTap: () => _onItemPressed(item),
      child: Container(
        child: Text(item.toString()),
      ),
    );
  }

  void _onItemPressed(PurchaseDetails item) {
    dispatchAsyncAction(IsPurchasesAvailableAsyncAction())
        .listen((action) => action
          ..onSuccess((isAvailable) => _onPurchaseAvailableSuccess(
                item: item,
                isAvailable: isAvailable,
              ))
          ..onError((error) => _onPurchaseAvailableError(error: error)));
  }

  void _onPurchaseAvailableSuccess({
    @required PurchaseDetails item,
    @required bool isAvailable,
  }) {
    if (isAvailable) {
      _purchaseItem(item);
    } else {
      showErrorDialog(context: context, message: Strings.storesUnavailable);
    }
  }

  void _onPurchaseAvailableError({dynamic error}) {
    handleError(context: context, exception: error);
  }

  void _purchaseItem(PurchaseDetails item) {
    // Buy same product again
    dispatchAsyncAction(QueryProductsForSaleAsyncAction(ids: {item.productID}))
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
}
