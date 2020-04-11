import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/assets/business_asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/assets/cash_asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/assets/debenture_asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/assets/insurance_asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/assets/other_asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/assets/realty_asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/assets/stock_asset_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/expense_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/income_response_model.dart';
import 'package:cash_flow/models/network/responses/possessions_state/liability_response_model.dart';
import 'package:cash_flow/models/state/posessions_state/assets/business_asset_item.dart';
import 'package:cash_flow/models/state/posessions_state/assets/cash_asset_item.dart';
import 'package:cash_flow/models/state/posessions_state/assets/debenture_asset_item.dart';
import 'package:cash_flow/models/state/posessions_state/assets/insurance_asset_item.dart';
import 'package:cash_flow/models/state/posessions_state/assets/other_asset_item.dart';
import 'package:cash_flow/models/state/posessions_state/assets/realty_asset_item.dart';
import 'package:cash_flow/models/state/posessions_state/assets/stock_asset_item.dart';
import 'package:cash_flow/models/state/posessions_state/possession_asset.dart';
import 'package:cash_flow/models/state/posessions_state/possession_expense.dart';
import 'package:cash_flow/models/state/posessions_state/possession_income.dart';
import 'package:cash_flow/models/state/posessions_state/possession_liability.dart';
import 'package:cash_flow/models/state/posessions_state/user_possession_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

UserPossessionState mapToPossessionState(DocumentSnapshot response) {
  final document = response.data['possessionState']['user1'];

  return UserPossessionState((b) => b
    ..assets = _getAssets(document)
    ..liabilities = _getLiabilities(document)
    ..expenses = _getExpenses(document)
    ..incomes = _getIncomes(document));
}

PossessionAssetBuilder _getAssets(document) {
  final List<InsuranceAssetItem> insurances = [];
  final List<DebentureAssetItem> debentures = [];
  final List<StockAssetItem> stocks = [];
  final List<RealtyAssetItem> realty = [];
  final List<BusinessAssetItem> businesses = [];
  final List<CashAssetItem> cash = [];
  final List<OtherAssetItem> other = [];

  List.from(document['assets'])
      .map(
          (json) => _ResponsePair(AssetResponseModel.fromJson(json).type, json))
      .forEach((pair) {
    switch (pair.type) {
      case AssetType.insurance:
        insurances.add(_buildInsurance(pair.json));
        break;
      case AssetType.debenture:
        debentures.add(_buildDebenture(pair.json));
        break;
      case AssetType.stocks:
        stocks.add(_buildStocks(pair.json));
        break;
      case AssetType.realty:
        realty.add(_buildRealty(pair.json));
        break;
      case AssetType.business:
        businesses.add(_buildBusiness(pair.json));
        break;
      case AssetType.cash:
        cash.add(_buildCash(pair.json));
        break;
      case AssetType.other:
        other.add(_buildOther(pair.json));
        break;
      default:
        break;
    }
  });

  final insurancesSum = insurances.fold(0, (sum, item) => sum += item.value);
  final debenturesSum = debentures.fold(0, (sum, item) => sum += item.total);
  final stocksSum = stocks.fold(0, (sum, item) => sum += item.total);
  final realtySum = realty.fold(0, (sum, item) => sum += item.cost);
  final businessesSum = businesses.fold(0, (sum, item) => sum += item.cost);
  final otherSum = other.fold(0, (sum, item) => sum += item.cost);

  return PossessionAssetBuilder()
    ..cash = cash.fold(0, (sum, item) => sum += item.value)
    ..sum = insurancesSum +
        debenturesSum +
        stocksSum +
        realtySum +
        businessesSum +
        otherSum
    ..insurances = insurances
    ..debentures = debentures
    ..stocks = stocks
    ..realty = realty
    ..businesses = businesses
    ..other = other;
}

CashAssetItem _buildCash(Map<String, dynamic> json) {
  final parsedItem = CashAssetResponseModel.fromJson(json);

  return CashAssetItem((b) => b
    ..name = parsedItem.name
    ..value = parsedItem.value);
}

OtherAssetItem _buildOther(Map<String, dynamic> json) {
  final parsedItem = OtherAssetResponseModel.fromJson(json);

  return OtherAssetItem((b) => b
    ..cost = parsedItem.cost
    ..downPayment = parsedItem.downPayment
    ..name = parsedItem.name);
}

BusinessAssetItem _buildBusiness(Map<String, dynamic> json) {
  final parsedItem = BusinessAssetResponseModel.fromJson(json);

  return BusinessAssetItem((b) => b
    ..cost = parsedItem.cost
    ..downPayment = parsedItem.downPayment
    ..name = parsedItem.name);
}

RealtyAssetItem _buildRealty(Map<String, dynamic> json) {
  final parsedItem = RealtyAssetResponseModel.fromJson(json);

  return RealtyAssetItem((b) => b
    ..cost = parsedItem.cost
    ..downPayment = parsedItem.downPayment
    ..name = parsedItem.name);
}

StockAssetItem _buildStocks(Map<String, dynamic> json) {
  final parsedItem = StockAssetResponseModel.fromJson(json);

  return StockAssetItem((b) => b
    ..count = parsedItem.count
    ..name = parsedItem.name
    ..itemPrice = parsedItem.purchasePrice
    ..total = parsedItem.total);
}

DebentureAssetItem _buildDebenture(Map<String, dynamic> json) {
  final parsedItem = DebentureAssetResponseModel.fromJson(json);

  return DebentureAssetItem((b) => b
    ..count = parsedItem.count
    ..name = parsedItem.name
    ..purchasePrice = parsedItem.total ~/ parsedItem.count
    ..total = parsedItem.total);
}

InsuranceAssetItem _buildInsurance(Map<String, dynamic> json) {
  final parsedItem = InsuranceAssetResponseModel.fromJson(json);

  return InsuranceAssetItem((b) => b
    ..name = parsedItem.name
    ..value = parsedItem.value);
}

List<PossessionLiability> _getLiabilities(document) {
  return List.from(document['liabilities'])
      .map((json) => LiabilityResponseModel.fromJson(json))
      .map((item) => PossessionLiability((b) => b
        ..name = item.name
        ..type = item.type
        ..value = item.value))
      .toList();
}

List<PossessionExpense> _getExpenses(document) {
  return List.from(document['expenses'])
      .map((json) => ExpenseResponseModel.fromJson(json))
      .map((item) => PossessionExpense((b) => b
        ..name = item.name
        ..value = item.value))
      .toList();
}

PossessionIncomeBuilder _getIncomes(document) {
  final incomesList = List.from(document['incomes'])
      .map((json) => IncomeResponseModel.fromJson(json))
      .toList();

  return PossessionIncomeBuilder()
    ..salary = incomesList
        .where((income) => income.type == IncomeType.salary)
        .fold(0, (sum, item) => sum + item.value)
    ..investments = incomesList
        .where((income) => income.type == IncomeType.investment)
        .fold(0, (sum, item) => sum + item.value)
    ..business = incomesList
        .where((income) => income.type == IncomeType.business)
        .fold(0, (sum, item) => sum + item.value)
    ..realty = incomesList
        .where((income) => income.type == IncomeType.realty)
        .fold(0, (sum, item) => sum + item.value)
    ..other = incomesList
        .where((income) => income.type == IncomeType.other)
        .fold(0, (sum, item) => sum + item.value);
}

class _ResponsePair {
  const _ResponsePair(this.type, this.json);

  final AssetType type;
  final Map<String, dynamic> json;
}
