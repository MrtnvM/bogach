import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_player_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class BusinessBuyGameEvent extends HookWidget {
  BusinessBuyGameEvent(this.event) : assert(event != null);

  final GameEvent event;
  BusinessBuyEventData get eventData => event.data;
  final actionRunner = useActionRunner();

  @override
  Widget build(BuildContext context) {
    return GameEventWidget(
      icon: Icons.business,
      name: event.name,
      buttonsState: ButtonsState.normal,
      buttonsProperties: ButtonsProperties(
        onConfirm: () => _sendPlayerAction(context),
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
    return Text(
      event.description,
      style: Styles.bodyBlack,
    );
  }

  Widget _buildOfferedPrice() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: Strings.offeredPrice, style: Styles.bodyBlack),
          const WidgetSpan(
              child: SizedBox(
            width: 4,
          )),
          TextSpan(
            text: eventData.fairPrice.toPrice(),
            style: Styles.bodyBlack,
          ),
        ],
      ),
    );
  }

  void _sendPlayerAction(BuildContext context) {
    final playerAction = BusinessBuyPlayerAction(
      const BuySellAction.buy(),
      event.id,
    );

    final action = SendPlayerMoveAsyncAction(playerAction, event.id);

    actionRunner
        .runAsyncAction(action)
        .catchError((error) => handleError(context: context, exception: error));
  }

  void _skipPlayerAction() {
    actionRunner.runAction(SkipPlayerMoveAction());
  }
}
