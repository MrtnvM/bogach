import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsSender {
  AnalyticsSender._();

  static final firebaseAnalytics = FirebaseAnalytics();

  static bool isEnabled = false;
  static String _userId;

  /// ----------------------------------------------------------------
  /// Gameboard events
  /// ----------------------------------------------------------------

  static void gameboardFinancesTabOpen() =>
      _send('gameboard_finances_tab_open');

  static void gameboardProgressTabOpen() =>
      _send('gameboard_progress_tab_open');

  static void buySellStock(
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

    final eventName = action.map(
      buy: (_) => 'stock_buy_event',
      sell: (_) => 'stock_sell_event',
    );

    _send(eventName, params);
  }

  static void skipBuySellStock(
    BuySellAction action,
    String stockName,
    double price,
  ) {
    final params = {'stock_name': stockName, 'stock_price': price};

    final eventName = action.map(
      buy: (_) => 'stock_skip_buy_event',
      sell: (_) => 'stock_skip_sell_event',
    );

    _send(eventName, params);
  }

  static void buyBusiness(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};
    _send('business_buy_event', params);
  }

  static void skipBuyBusiness(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};
    _send('business_skip_buy_event', params);
  }

  static void sellBusiness(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};
    _send('business_sell_event', params);
  }

  static void skipSellBusiness(String businessName, int price) {
    final params = {'business_name': businessName, 'business_price': price};
    _send('business_skip_sell_event', params);
  }

  static void buySellDebenture(
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

    _send(eventName, params);
  }

  static void skipBuySellDebenture(
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

    _send(eventName, params);
  }

  static void expenseEvent(String expenseName, int value) {
    final params = {
      'expense_name': expenseName,
      'expense_value': value,
    };

    _send('expense_event', params);
  }

  static void incomeEvent(String incomeName, int value) {
    final params = {
      'income_name': incomeName,
      'income_value': value,
    };

    _send('income_event', params);
  }

  static void buyInsurance(String insuranceEvent, int price) {
    final params = {'insurance_name': insuranceEvent, 'business_price': price};

    _send('business_buy_event', params);
  }

  static void skipBuyInsurance(String insuranceEvent, int price) {
    final params = {'insurance_name': insuranceEvent, 'business_price': price};

    _send('business_skip_buy_event', params);
  }

  static void monthlyExpense(String expenseName, int value) {
    final params = {
      'monthly_expense_name': expenseName,
      'monthly_expense_value': value,
    };

    _send('monthly_expense_event', params);
  }

  static void buyRealEstate(String realEstateName, int price) {
    final params = {
      'real_estate_name': realEstateName,
      'real_estate_price': price,
    };

    _send('real_estate_buy_event', params);
  }

  static void skipBuyRealEstate(String realEstateName, int price) {
    final params = {
      'real_estate_name': realEstateName,
      'real_estate_price': price,
    };

    _send('real_estate_skip_buy_event', params);
  }

  /// ----------------------------------------------------------------
  /// Game events
  /// ----------------------------------------------------------------

  static void gameStart() => _send('game_start');
  static void gameEnd() => _send('game_end');
  static void gameExit() => _send('game_exit');
  static void gameWin() => _send('game_win');
  static void gameLoss() => _send('game_loss');

  /// ----------------------------------------------------------------
  /// Singleplayer events
  /// ----------------------------------------------------------------

  static void singleplayerGameStart() => _send('singleplayer_game_start');
  static void singleplayerPageOpen() => _send('singleplayer_page_open');
  static void singleplayerContinueGame() => _send('singleplayer_game_continue');
  static void singleplayerTemplateSelected(String templateName) =>
      _send('singleplayer_template_selected', {'template_name': templateName});

  /// ----------------------------------------------------------------
  /// Multiplayer events
  /// ----------------------------------------------------------------

  static void multiplayerGameStart() => _send('multiplayer_game_start');
  static void multiplayerGameEnd() => _send('multiplayer_game_end');

  static void multiplayerLevelsPageOpen() =>
      _send('multiplayer_levels_page_open');

  static void multiplayerInviteLinkCreated() =>
      _send('multiplayer_invite_link_created');

  static void multiplayerPurchasePageOpen() =>
      _send('multiplayer_purchase_page_open');

  static void multiplayerGamesPurchased() =>
      _send('multiplayer_games_purchased');

  static void multiplayerTemplateSelected(String templateName) =>
      _send('multiplayer_template_selected', {'template_name': templateName});

  static void multiplayer1GameBought() => _send('multiplayer_1_game_bought');
  static void multiplayer5GamesBought() => _send('multiplayer_5_games_bought');
  static void multiplayer10GamesBought() =>
      _send('multiplayer_10_games_bought');

  /// ----------------------------------------------------------------
  /// Quests events
  /// ----------------------------------------------------------------

  static void questStart(String quest) =>
      _send('quest_start', {'quest': quest});

  static void questContinue(String quest) =>
      _send('quest_continue', {'quest': quest});

  static void questCompleted(String quest) =>
      _send('quest_completed', {'quest': quest});

  static void questFailed(String quest) =>
      _send('quest_failed', {'quest': quest});

  static void questsFirstOpen() => _send('quests_first_open');
  static void questsPageOpen() => _send('quests_page_open');

  static void questsPurchasePageOpen() => _send('quests_purchase_page_open');
  static void questsPurchaseStarted() => _send('quests_purchase_started');
  static void questsPurhased() => _send('quests_purhased');

  static void questSelected() => _send('quests_quest_selected');
  static void questsFirstQuestSelected() =>
      _send('quests_first_quest_selected');
  static void questsSecondQuestSelected() =>
      _send('quests_second_quest_selected');

  /// ----------------------------------------------------------------
  /// Onboarding
  /// ----------------------------------------------------------------

  static void onboardingFirstPageOpen() => _send(
        'onboarding_first_page_open',
      );

  static void onboardingSecondPageOpen() => _send(
        'onboarding_second_page_open',
      );

  static void onboardingThirdPageOpen() => _send(
        'onboarding_third_page_open',
      );

  static void onboardingCompleted() => _send('onboarding_completed');

  /// ----------------------------------------------------------------
  /// Tutorial
  /// ----------------------------------------------------------------

  static void tutorialStarted() => _send('tutorial_started');
  static void tutorialCompleted() => _send('tutorial_ completed');
  static void tutorialSkip() => _send('tutorial_ skip');

  // TODO(Maxim): Added steps for tutorial

  /// ----------------------------------------------------------------
  /// App events
  /// ----------------------------------------------------------------

  static void appLaunched() => _send('app_open');
  static void signIn() => _send('sign_in');
  static void singInFailed() => _send('sing_in_failed');

  /// ----------------------------------------------------------------
  /// Common methods
  /// ----------------------------------------------------------------

  static void setUserId(String userId) {
    _userId = userId;

    firebaseAnalytics.setUserId(userId);
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  static void _send(
    String eventName, [
    Map<String, dynamic> parameters = const {},
  ]) {
    if (!isEnabled) {
      return;
    }

    print(
      'ANALYTICS EVENT: $eventName'
      '${parameters.isNotEmpty ? '\nPARAMS: $parameters' : ''}',
    );

    if (_userId != null) {
      parameters = {...parameters, 'userId': _userId};
    }

    firebaseAnalytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }
}
