import 'package:cash_flow/models/domain/account_state.dart';
import 'package:cash_flow/models/domain/game_template.dart';
import 'package:cash_flow/models/domain/target_data.dart';
import 'package:cash_flow/models/network/responses/game_template_response_model.dart';

List<GameTemplate> mapToGameTemplates(List<GameTemplateResponseModel> games) {
  return games
      .map((game) => GameTemplate(
          id: game.id,
          name: game.name,
          accountState: AccountState(
              cash: game.accountState.cash,
              cashFlow: game.accountState.cashFlow,
              credit: game.accountState.credit),
          target: TargetData(type: game.target.type, value: game.target.value)))
      .toList();
}
