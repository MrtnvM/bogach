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
import 'package:cash_flow/presentation/gameboard/widgets/table/detail_row.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AssetsList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final currentMonth = useCurrentGameState().monthNumber;
    final assets = useCurrentGame(
      (g) => g.participants[userId].possessionState.assets,
    );

    final cashAssets = _getAssets<CashAsset>(assets, AssetType.cash);
    final totalCash = _calculateSum<CashAsset>(cashAssets, (a) => a.value);

    final insuranses =
        _getAssets<InsuranceAsset>(assets, AssetType.insurance).where((i) {
      final monthsLeft = i.duration - (currentMonth - i.fromMonth);
      return monthsLeft >= 0;
    }).toList();
    final totalInsurance = _calculateSumInt<InsuranceAsset>(
      insuranses,
      (a) => a.cost,
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

    return InfoTable(
      title: Strings.assets,
      titleValue: totalAssets.toPrice(),
      titleTextStyle: Styles.tableHeaderTitleBlack,
      titleValueStyle: Styles.tableHeaderValueBlack,
      rows: <Widget>[
        TitleRow(title: '${Strings.cash}:', value: totalCash.toPrice()),
        DetailRow(
          title: Strings.insuranceTitle,
          value: totalInsurance.toPrice(),
          details: insuranses.map((insurance) {
            final monthsLeft =
                insurance.duration - (currentMonth - insurance.fromMonth);

            return '${insurance.name}; '
                '${Strings.defence} - ${insurance.value.toPrice()}; '
                '${Strings.cost} - ${insurance.cost.toPrice()}; '
                '${Strings.expires(monthsLeft)}';
          }).toList(),
        ),
        DetailRow(
          title: Strings.investments,
          value: totalDebentures.toPrice(),
          details: debentures.map(
            (i) {
              final description = Strings.itemsPerPrice(
                count: i.count,
                price: i.averagePrice.toPrice(),
              );

              return '${i.name} '
                  '(${i.profitabilityPercent.toPercent()}); '
                  '$description';
            },
          ).toList(),
        ),
        DetailRow(
          title: Strings.stock,
          value: totalStocks.toPrice(),
          details: stocks.map(
            (i) {
              final description = Strings.itemsPerPrice(
                count: i.countInPortfolio,
                price: i.averagePrice.toPrice(),
              );

              return '${i.name}; $description';
            },
          ).toList(),
        ),
        DetailRow(
          title: Strings.property,
          value: totalRealties.toPrice(),
          details: realties
              .map((i) => '${i.name}; '
                  '${Strings.cost} - ${i.downPayment.toPrice()}')
              .toList(),
        ),
        DetailRow(
          title: Strings.business,
          value: totalBusinesses.toPrice(),
          details: businesses
              .map((i) => '${i.name}; '
                  '${Strings.firstPayment} - ${i.downPayment.toPrice()}')
              .toList(),
        ),
        DetailRow(
          title: Strings.other,
          value: totalOtherAssets.toPrice(),
          details: otherAssets
              .map((i) => '${i.name}; '
                  '${Strings.firstPayment} - ${i.downPayment.toPrice()}')
              .toList(),
        ),
      ],
    );
  }

  List<T> _getAssets<T>(List<Asset> assets, AssetType type) {
    return assets.where((a) => a.type == type).cast<T>().toList();
  }

  double _calculateSum<T>(List<T> assets, double Function(T) converter) {
    return assets.fold(0.0, (s, a) => s + converter(a));
  }

  int _calculateSumInt<T>(List<T> assets, int Function(T) converter) {
    return assets.fold(0, (s, a) => s + converter(a));
  }
}
