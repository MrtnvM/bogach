import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsSender {
  factory AnalyticsSender() {
    return _instance;
  }

  AnalyticsSender._internal();

  static final AnalyticsSender _instance = AnalyticsSender._internal();
  static final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

  static void sendBuySellStockEvent(
    BuySellAction action,
    int count,
    String stockName,
    double price,
  ) {
    final params = {
      'stock_count': count,
      'stock_name': stockName,
      'stock_price': price
    };

    final eventName = action.map<String>(
      buy: (_) => 'stock_buy_event',
      sell: (_) => 'stock_sell_event',
    );

    firebaseAnalytics.logEvent(
      name: eventName,
      parameters: params,
    );
  }

  static void sendSkipBuySellStockEvent(
    BuySellAction action,
    String stockName,
    double price,
  ) {
    final params = {'stock_name': stockName, 'stock_price': price};

    final eventName = action.map<String>(
      buy: (_) => 'stock_skip_buy_event',
      sell: (_) => 'stock_skip_sell_event',
    );

    firebaseAnalytics.logEvent(
      name: eventName,
      parameters: params,
    );
  }

  static void sendBuyBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    firebaseAnalytics.logEvent(
      name: 'business_buy_event',
      parameters: params,
    );
  }

  static void sendSkipBuyBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    firebaseAnalytics.logEvent(
      name: 'business_skip_buy_event',
      parameters: params,
    );
  }

  static void sendSellBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    firebaseAnalytics.logEvent(
      name: 'business_sell_event',
      parameters: params,
    );
  }

  static void sendSkipSellBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    firebaseAnalytics.logEvent(
      name: 'business_skip_sell_event',
      parameters: params,
    );
  }

  static void sendBuySellDebentureEvent(
    BuySellAction action,
    int count,
    String debentureName,
    double price,
  ) {
    final params = {
      'debenture_name': debentureName,
      'debenture_price': price,
      'debenture_count': count,
    };

    final eventName = action.map<String>(
      buy: (_) => 'debenture_buy_event',
      sell: (_) => 'debenture_sell_event',
    );

    firebaseAnalytics.logEvent(
      name: eventName,
      parameters: params,
    );
  }

  static void sendSkipBuySellDebentureEvent(
    BuySellAction action,
    String debentureName,
    double price,
  ) {
    final params = {
      'debenture_name': debentureName,
      'debenture_price': price,
    };

    final eventName = action.map<String>(
      buy: (_) => 'debenture_skip_buy_event',
      sell: (_) => 'debenture_skip_sell_event',
    );

    firebaseAnalytics.logEvent(
      name: eventName,
      parameters: params,
    );
  }

  static void sendExpenseEvent(String expenseName, int value) {
    final params = {
      'expense_name': expenseName,
      'expense_value': value,
    };

    firebaseAnalytics.logEvent(
      name: 'expense_event',
      parameters: params,
    );
  }

  static void sendIncomeEvent(String incomeName, int value) {
    final params = {
      'income_name': incomeName,
      'income_value': value,
    };

    firebaseAnalytics.logEvent(
      name: 'income_event',
      parameters: params,
    );
  }

  static void sendBuyInsuranceEvent(String insuranceEvent, int price) {
    final params = {'insurance_name': insuranceEvent, 'business_price': price};

    firebaseAnalytics.logEvent(
      name: 'business_buy_event',
      parameters: params,
    );
  }

  static void sendSkipBuyInsuranceEvent(String insuranceEvent, int price) {
    final params = {'insurance_name': insuranceEvent, 'business_price': price};

    firebaseAnalytics.logEvent(
      name: 'business_skip_buy_event',
      parameters: params,
    );
  }

  static void sendMonthlyExpenseEvent(String expenseName, int value) {
    final params = {
      'monthly_expense_name': expenseName,
      'monthly_expense_value': value,
    };

    firebaseAnalytics.logEvent(
      name: 'monthly_expense_event',
      parameters: params,
    );
  }

  static void sendBuyRealEstateEvent(String realEstateName, int price) {
    final params = {
      'real_estate_name': realEstateName,
      'real_estate_price': price,
    };

    firebaseAnalytics.logEvent(
      name: 'real_estate_buy_event',
      parameters: params,
    );
  }

  static void sendSkipBuyRealEstateEvent(String realEstateName, int price) {
    final params = {
      'real_estate_name': realEstateName,
      'real_estate_price': price,
    };

    firebaseAnalytics.logEvent(
      name: 'real_estate_skip_buy_event',
      parameters: params,
    );
  }

  static void sendContinueGame(String userId) {
    final params = {
      'userId': userId,
    };

    firebaseAnalytics.logEvent(
      name: 'continue_game_event',
      parameters: params,
    );
  }

  static void sendMultiplayerGame(String userId) {
    final params = {
      'userId': userId,
    };

    firebaseAnalytics.logEvent(
      name: 'multiplayer_game_event',
      parameters: params,
    );
  }

  static void sendNewGame(String userId) {
    final params = {
      'userId': userId,
    };

    firebaseAnalytics.logEvent(
      name: 'new_game_event',
      parameters: params,
    );
  }
}
