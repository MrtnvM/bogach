import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/business/business_asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/cash/cash_asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/debenture/debenture_asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/insurance/insurance_asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/other/other_asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/realty/realty_asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/stock/stock_asset.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/indicators_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class AssetsList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final assets = useCurrentGame((g) => g.possessionState[userId].assets);

    final cashAssets = _getAssets<CashAsset>(assets, AssetType.cash);
    final totalCash = _calculateSum<CashAsset>(cashAssets, (a) => a.value);

    final insuranses = _getAssets<InsuranceAsset>(assets, AssetType.insurance);
    final totalInsurance = _calculateSum<InsuranceAsset>(
      insuranses,
      (a) => a.value,
    );

    final debentures = _getAssets<DebentureAsset>(assets, AssetType.debenture);
    final totalDebentures = _calculateSum<DebentureAsset>(
        debentures, (a) => a.averagePrice * a.count);

    final stocks = _getAssets<StockAsset>(assets, AssetType.stock);
    final totalStocks = _calculateSum<StockAsset>(
        stocks, (a) => a.averagePrice * a.countInPortfolio);

    final businesses = _getAssets<BusinessAsset>(assets, AssetType.business);
    final totalBusinesses =
        _calculateSum<BusinessAsset>(businesses, (a) => a.downPayment);

    final realties = _getAssets<RealtyAsset>(assets, AssetType.realty);
    final totalRealties =
        _calculateSum<RealtyAsset>(realties, (a) => a.downPayment);

    final otherAssets = _getAssets<OtherAsset>(assets, AssetType.other);
    final totalOtherAssets =
        _calculateSum<OtherAsset>(otherAssets, (a) => a.value);

    final totalAssets = [
      totalCash,
      totalInsurance,
      totalDebentures,
      totalStocks,
      totalBusinesses,
      totalRealties,
      totalOtherAssets
    ].fold<double>(0.0, (s, i) => s + i);

    return IndicatorsTable(
      context: context,
      name: Strings.assets,
      result: totalAssets.toPrice(),
      rows: <RowHeaderItem>[
        RowItem(name: '${Strings.cash}:', value: totalCash.toPrice()),
        const RowHeaderAttributeItem(
          name: Strings.insuranceTitle,
          attribute: Strings.cost,
          value: Strings.defence,
        ),
        ..._buildInsurances(insuranses),
        const RowHeaderAttributeItem(
          name: Strings.investments,
          attribute: Strings.count,
          value: Strings.sum,
        ),
        ..._buildDebentures(debentures),
        const RowHeaderAttributeItem(
          name: Strings.stock,
          attribute: Strings.count,
          value: Strings.sum,
        ),
        ..._buildStocks(stocks),
        const RowHeaderAttributeItem(
          name: Strings.property,
          attribute: Strings.firstPayment,
          value: Strings.cost,
        ),
        ..._buildRealties(realties),
        const RowHeaderAttributeItem(
          name: Strings.business,
          attribute: Strings.firstPayment,
          value: Strings.cost,
        ),
        ..._buildBusinesses(businesses),
        const RowHeaderAttributeItem(
          name: Strings.other,
          attribute: Strings.firstPayment,
          value: Strings.cost,
        ),
        ..._buildOtherAssets(otherAssets),
      ],
    );
  }

  List<RowAttributeItem> _buildInsurances(List<InsuranceAsset> insurances) {
    return [
      for (var insurance in insurances)
        RowAttributeItem(
          name: insurance.name,
          attribute: insurance.value.toPrice(),
          value: insurance.value.toPrice(),
        )
    ];
  }

  List<RowHeaderItem> _buildStocks(List<StockAsset> stocks) {
    return [
      for (var stock in stocks)
        RowAttributeItem(
          name: stock.name,
          attribute: Strings.itemsPerPrice(
            count: stock.countInPortfolio,
            price: stock.averagePrice.toPrice(),
          ),
          value: (stock.averagePrice * stock.countInPortfolio).toPrice(),
        )
    ];
  }

  List<RowAttributeItem> _buildDebentures(List<DebentureAsset> debentures) {
    return [
      for (var debenture in debentures)
        RowAttributeItem(
          name: debenture.name,
          attribute: '${debenture.count}',
          value: debenture.averagePrice.toPrice(),
        )
    ];
  }

  List<RowAttributeItem> _buildRealties(List<RealtyAsset> realties) {
    return [
      for (var realty in realties)
        RowAttributeItem(
          name: realty.name,
          attribute: '${realty.downPayment}',
          value: realty.cost.toPrice(),
        )
    ];
  }

  List<RowAttributeItem> _buildBusinesses(List<BusinessAsset> businesses) {
    return [
      for (var business in businesses)
        RowAttributeItem(
          name: business.name,
          attribute: '${business.downPayment}',
          value: business.buyPrice.toPrice(),
        )
    ];
  }

  List<RowAttributeItem> _buildOtherAssets(List<OtherAsset> otherAssets) {
    return [
      for (var otherAsset in otherAssets)
        RowAttributeItem(
          name: otherAsset.name,
          attribute: '${otherAsset.downPayment}',
          value: otherAsset.value.toPrice(),
        )
    ];
  }

  List<T> _getAssets<T>(List<Asset> assets, AssetType type) {
    return assets.where((a) => a.type == type).cast<T>().toList();
  }

  double _calculateSum<T>(List<T> assets, double Function(T) converter) {
    return assets.fold(0.0, (s, a) => s + converter(a));
  }
}
