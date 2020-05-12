import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_player_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class BusinessBuyGameEvent extends StatefulWidget {
  const BusinessBuyGameEvent(this.event) : assert(event != null);

  final GameEvent event;

  @override
  State<StatefulWidget> createState() {
    return BusinessBuyGameEventState();
  }
}

class BusinessBuyGameEventState extends State<BusinessBuyGameEvent>
    with ReduxState {
  GameEvent get event => widget.event;
  BusinessBuyEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    return GameEventWidget(
      icon: Icons.business,
      name: Strings.newBusinessTitle,
      buttonsState: ButtonsState.normal,
      buttonsProperties: ButtonsProperties(
        onConfirm: _sendPlayerAction,
        onSkip: _skipPlayerAction,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    final map = {
      Strings.debt: eventData.debt.toPrice(),
      Strings.passiveIncomePerMonth: eventData.passiveIncomePerMonth.toPrice(),
      Strings.roi: eventData.payback.toPercent(),
    };

    return InfoTable(map);
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(),
          const SizedBox(height: 8),
          _buildOfferedPrice(),
          const SizedBox(height: 8),
          _buildInfo(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      Strings.newBusinessDesc,
      style: Styles.body2,
    );
  }

  Widget _buildOfferedPrice() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: Strings.offeredPrice, style: Styles.body1),
          const WidgetSpan(
              child: SizedBox(
            width: 4,
          )),
          TextSpan(
            text: eventData.fairPrice.toPrice(),
            style: Styles.body2.copyWith(color: ColorRes.blue),
          ),
        ],
      ),
    );
  }

  void _sendPlayerAction() {
    final playerAction = BusinessBuyPlayerAction(
      const BuySellAction.buy(),
      event.id,
    );

    final action = SendPlayerMoveAsyncAction(playerAction, event.id);

    dispatchAsyncAction(action).listen(
      (action) => action
        ..onError((error) => handleError(context: context, exception: error)),
    );
  }

  void _skipPlayerAction() {
    dispatch(SkipPlayerMoveAction());
  }
}
