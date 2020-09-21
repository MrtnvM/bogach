import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsSender {
  AnalyticsSender._();

  static final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

  static bool isEnabled = false;

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

    _sendEvent(eventName, params);
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

    _sendEvent(eventName, params);
  }

  static void sendBuyBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    _sendEvent('business_buy_event', params);
  }

  static void sendSkipBuyBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    _sendEvent('business_skip_buy_event', params);
  }

  static void sendSellBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    _sendEvent('business_sell_event', params);
  }

  static void sendSkipSellBusinessEvent(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};

    _sendEvent('business_skip_sell_event', params);
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

    _sendEvent(eventName, params);
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

    _sendEvent(eventName, params);
  }

  static void sendExpenseEvent(String expenseName, int value) {
    final params = {
      'expense_name': expenseName,
      'expense_value': value,
    };

    _sendEvent('expense_event', params);
  }

  static void sendIncomeEvent(String incomeName, int value) {
    final params = {
      'income_name': incomeName,
      'income_value': value,
    };

    _sendEvent('income_event', params);
  }

  static void sendBuyInsuranceEvent(String insuranceEvent, int price) {
    final params = {'insurance_name': insuranceEvent, 'business_price': price};

    _sendEvent('business_buy_event', params);
  }

  static void sendSkipBuyInsuranceEvent(String insuranceEvent, int price) {
    final params = {'insurance_name': insuranceEvent, 'business_price': price};

    _sendEvent('business_skip_buy_event', params);
  }

  static void sendMonthlyExpenseEvent(String expenseName, int value) {
    final params = {
      'monthly_expense_name': expenseName,
      'monthly_expense_value': value,
    };

    _sendEvent('monthly_expense_event', params);
  }

  static void sendBuyRealEstateEvent(String realEstateName, int price) {
    final params = {
      'real_estate_name': realEstateName,
      'real_estate_price': price,
    };

    _sendEvent('real_estate_buy_event', params);
  }

  static void sendSkipBuyRealEstateEvent(String realEstateName, int price) {
    final params = {
      'real_estate_name': realEstateName,
      'real_estate_price': price,
    };

    _sendEvent('real_estate_skip_buy_event', params);
  }

  static void sendContinueGame(String userId) {
    final params = {
      'userId': userId,
    };

    _sendEvent('continue_game_event', params);
  }

  static void sendMultiplayerGame(String userId) {
    final params = {
      'userId': userId,
    };

    _sendEvent('multiplayer_game_event', params);
  }

  static void sendNewGame(String userId) {
    final params = {
      'userId': userId,
    };

    _sendEvent('new_game_event', params);
  }

  static void templateSelected(String templateName) {
    final params = {
      'template_name': templateName,
    };

    _sendEvent('template_selected_event', params);
  }

  static void _sendEvent(String eventName, Map<String, dynamic> parameters) {
    if (!isEnabled) {
      return;
    }

    firebaseAnalytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }
}
