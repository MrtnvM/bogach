import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/state/game/posessions/assets/business_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/debenture_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/insurance_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/other_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/realty_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/stock_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/possession_asset.dart';
import 'package:cash_flow/models/state/game/posessions/possession_expense.dart';
import 'package:cash_flow/models/state/game/posessions/possession_income.dart';
import 'package:cash_flow/models/state/game/posessions/possession_liability.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/indicators_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class CashFlowGrid extends StatefulWidget {
  const CashFlowGrid();

  @override
  _CashFlowGridState createState() => _CashFlowGridState();
}

class _CashFlowGridState extends State<CashFlowGrid> with ReduxState {
  @override
  Widget build(BuildContext context) {
    return AppStateConnector<GameState>(
      converter: (s) => s.gameState,
      builder: (context, state) => _buildBody(state),
    );
  }

  Widget _buildBody(GameState state) {
    return ListView(
      children: <Widget>[
        _buildIncomes(state.possessions.incomes),
        const SizedBox(height: 32),
        _buildExpenses(state.possessions.expenses),
        const SizedBox(height: 32),
        _buildAssets(state.possessions.assets),
        const SizedBox(height: 32),
        _buildLiabilities(state.possessions.liabilities),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildIncomes(PossessionIncome incomes) {
    return IndicatorsTable(
      context: context,
      name: Strings.incomes,
      result: incomes.sum.toPrice(),
      rows: [
        RowItem(name: Strings.salary, value: incomes.salary.toPrice()),
        RowItem(
            name: Strings.investments, value: incomes.investments.toPrice()),
        RowItem(name: Strings.business, value: incomes.business.toPrice()),
        RowItem(name: Strings.realty, value: incomes.realty.toPrice()),
        RowItem(name: Strings.other, value: incomes.other.toPrice()),
      ],
    );
  }

  Widget _buildExpenses(List<PossessionExpense> expenses) {
    return IndicatorsTable(
      context: context,
      name: Strings.expenses,
      result: expenses.fold<int>(0, (sum, item) => sum + item.value).toPrice(),
      rows: expenses
          .map((income) => RowItem(
                name: income.name,
                value: income.value.toPrice(),
              ))
          .toList(),
    );
  }

  Widget _buildAssets(PossessionAsset assets) {
    return IndicatorsTable(
      context: context,
      name: Strings.assets,
      result: assets.sum.toPrice(),
      rows: <RowHeaderItem>[
        RowItem(name: '${Strings.cash}:', value: assets.cash.toPrice()),
        const RowHeaderAttributeItem(
          name: Strings.insuranceTitle,
          attribute: Strings.cost,
          value: Strings.defence,
        ),
        ..._buildInsuranceItems(assets.insurances),
        const RowHeaderAttributeItem(
          name: Strings.investments,
          attribute: Strings.count,
          value: Strings.sum,
        ),
        ..._buildDebentureItems(assets.debentures),
        const RowHeaderAttributeItem(
            name: Strings.stock, attribute: Strings.count, value: Strings.sum),
        ..._buildStockItems(assets.stocks),
        const RowHeaderAttributeItem(
            name: Strings.property,
            attribute: Strings.firstPayment,
            value: Strings.cost),
        ..._buildRealtyItems(assets.realty),
        const RowHeaderAttributeItem(
            name: Strings.business,
            attribute: Strings.firstPayment,
            value: Strings.cost),
        ..._buildBusinessItems(assets.businesses),
        const RowHeaderAttributeItem(
            name: Strings.other,
            attribute: Strings.firstPayment,
            value: Strings.cost),
        ..._buildOtherItems(assets.other),
      ],
    );
  }

  Widget _buildLiabilities(List<PossessionLiability> liabilities) {
    return IndicatorsTable(
      context: context,
      name: Strings.liabilities,
      result:
          liabilities.fold<int>(0, (sum, item) => sum + item.value).toPrice(),
      rows: liabilities
          .map((item) => RowItem(name: item.name, value: item.value.toPrice()))
          .toList(),
    );
  }

  List<RowHeaderItem> _buildStockItems(
    List<StockAssetItem> stocks,
  ) {
    return stocks
        .map((item) => RowAttributeItem(
              name: item.name,
              attribute: Strings.itemsPerPrice(
                count: item.count,
                price: item.itemPrice.toPrice(),
              ),
              value: (item.itemPrice * item.count).toPrice(),
            ))
        .toList();
  }

  List<RowAttributeItem> _buildInsuranceItems(
    List<InsuranceAssetItem> insurances,
  ) {
    return insurances
        .map((item) => RowAttributeItem(
              name: item.name,
              attribute: item.value.toPrice(),
              value: item.value.toPrice(),
            ))
        .toList();
  }

  List<RowAttributeItem> _buildDebentureItems(
    List<DebentureAssetItem> debentures,
  ) {
    return debentures
        .map((item) => RowAttributeItem(
              name: item.name,
              attribute: '${item.count}',
              value: item.currentPrice.toPrice(),
            ))
        .toList();
  }

  List<RowAttributeItem> _buildRealtyItems(
    List<RealtyAssetItem> realty,
  ) {
    return realty
        .map((item) => RowAttributeItem(
              name: item.name,
              attribute: '${item.downPayment}',
              value: item.cost.toPrice(),
            ))
        .toList();
  }

  List<RowAttributeItem> _buildBusinessItems(
    List<BusinessAssetItem> businesses,
  ) {
    return businesses
        .map((item) => RowAttributeItem(
              name: item.name,
              attribute: '${item.downPayment}',
              value: item.cost.toPrice(),
            ))
        .toList();
  }

  List<RowAttributeItem> _buildOtherItems(
    List<OtherAssetItem> other,
  ) {
    return other
        .map((item) => RowAttributeItem(
              name: item.name,
              attribute: '${item.downPayment}',
              value: item.cost.toPrice(),
            ))
        .toList();
  }
}
