import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/models/domain/game_data.dart';
import 'package:cash_flow/models/domain/game_event.dart';
import 'package:cash_flow/models/domain/game_event_type.dart';
import 'package:cash_flow/models/domain/target_data.dart';
import 'package:cash_flow/models/network/responses/game/game_event_response_model.dart';
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
import 'package:cash_flow/models/network/responses/target_response_model.dart';
import 'package:cash_flow/models/state/game/account/account.dart';
import 'package:cash_flow/models/state/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/state/game/posessions/assets/business_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/cash_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/debenture_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/insurance_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/other_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/realty_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/stock_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/possession_asset.dart';
import 'package:cash_flow/models/state/game/posessions/possession_expense.dart';
import 'package:cash_flow/models/state/game/posessions/possession_income.dart';
import 'package:cash_flow/models/state/game/posessions/possession_liability.dart';
import 'package:cash_flow/models/state/game/posessions/user_possession_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

GameData mapToGameData(DocumentSnapshot response, String userId) {
  final data = response.data;

  final userPossessionState = mapToPossessionState(
    data['possessionState'],
    userId,
  );
  final account = mapToAccountState(data['accounts'], userId);
  final target = mapToTargetState(data['target']);
  final events = mapToGameEvents(data['currentEvents']);
  final gameState = mapToCurrentGameState(data['state']);

  return GameData(
    possessions: userPossessionState,
    target: target,
    events: events,
    account: account,
    gameState: gameState,
  );
}

GameData mapToRealtimeGameData(Event event, String userId) {
  final response = jsonDecode(jsonEncode(event.snapshot.value));

  final userPossessionState = mapToPossessionState(
    response['possessionState'],
    userId,
  );
  final account = mapToAccountState(response['accounts'], userId);
  final target = mapToTargetState(response['target']);
  final events = mapToGameEvents(response['currentEvents']);
  final gameState = mapToCurrentGameState(response['state']);

  return GameData(
    possessions: userPossessionState,
    target: target,
    events: events,
    account: account,
    gameState: gameState,
  );
}

final List<String> _gameEvents = [
  'debenture-price-changed-event',
  'stock-price-changed-event',
];
BuiltList<GameEvent> mapToGameEvents(List response) {
  return response
      .map((json) => GameEventResponseModel.fromJson(json))
      .where(
        (event) => _gameEvents.contains(event.type),
      )
      .map((event) {
    final type = GameEventType.fromJson(event.type);
    final eventData = type.parseGameEventData(event.data);

    return GameEvent(
      id: event.id,
      name: event.name,
      description: event.description,
      type: type,
      data: eventData,
    );
  }).toBuiltList();
}

TargetData mapToTargetState(Map<String, dynamic> response) {
  final target = TargetResponseModel.fromJson(response);

  return TargetData(value: target.value, type: target.type);
}

Account mapToAccountState(Map<String, dynamic> accountsData, String userId) {
  return Account.fromJson(accountsData[userId]);
}

CurrentGameState mapToCurrentGameState(Map<String, dynamic> gameState) {
  return CurrentGameState.fromJson(gameState);
}

UserPossessionState mapToPossessionState(
    Map<String, dynamic> response, String userId) {
  final document = response[userId];

  return UserPossessionState((b) => b
    ..assets = _getAssets(document)
    ..liabilities = _getLiabilities(document)
    ..expenses = _getExpenses(document)
    ..incomes = _getIncomes(document));
}

PossessionAssetBuilder _getAssets(document) {
  final insurances = <InsuranceAssetItem>[];
  final debentures = <DebentureAssetItem>[];
  final stocks = <StockAssetItem>[];
  final realty = <RealtyAssetItem>[];
  final businesses = <BusinessAssetItem>[];
  final cash = <CashAssetItem>[];
  final other = <OtherAssetItem>[];

  final allAssets = document['assets'];

  for (final json in allAssets) {
    final type = AssetResponseModel.fromJson(json).type;

    switch (type) {
      case AssetType.insurance:
        insurances.add(_buildInsurance(json));
        break;
      case AssetType.debenture:
        debentures.add(_buildDebenture(json));
        break;
      case AssetType.stock:
        stocks.add(_buildStocks(json));
        break;
      case AssetType.realty:
        realty.add(_buildRealty(json));
        break;
      case AssetType.business:
        businesses.add(_buildBusiness(json));
        break;
      case AssetType.cash:
        cash.add(_buildCash(json));
        break;
      case AssetType.other:
        other.add(_buildOther(json));
        break;
      default:
        break;
    }
  }

  final insurancesSum = insurances.fold(0.0, (sum, item) => sum += item.value);
  final debenturesSum = debentures.fold(
    0.0,
    (sum, item) => sum += item.averagePrice * item.count,
  );
  final stocksSum = stocks.fold(
    0.0,
    (sum, item) => sum += item.averagePrice * item.countInPortfolio,
  );
  final realtySum = realty.fold(0.0, (sum, item) => sum += item.cost);
  final businessesSum = businesses.fold(0.0, (sum, item) => sum += item.cost);
  final otherSum = other.fold(0.0, (sum, item) => sum += item.cost);

  return PossessionAssetBuilder()
    ..cash = cash.fold(0.0, (sum, item) => sum += item.value)
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
    ..countInPortfolio = parsedItem.countInPortfolio
    ..name = parsedItem.name
    ..averagePrice = parsedItem.averagePrice);
}

DebentureAssetItem _buildDebenture(Map<String, dynamic> json) {
  final parsedItem = DebentureAssetResponseModel.fromJson(json);

  return DebentureAssetItem((b) => b
    ..name = parsedItem.name
    ..nominal = parsedItem.nominal
    ..averagePrice = parsedItem.averagePrice
    ..count = parsedItem.count
    ..profitabilityPercent = parsedItem.profitabilityPercent);
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
