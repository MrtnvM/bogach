import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/models/network/responses/game_template_response_model.dart';

List<GameTemplate> mapToGameTemplates(List<GameTemplateResponseModel> games) {
  return games
      .map(
        (game) => GameTemplate(
          id: game.id!,
          name: game.name!,
          icon: game.icon!,
          image: game.image,
          accountState: Account(
            cash: game.accountState!.cash,
            cashFlow: game.accountState!.cashFlow,
            credit: game.accountState!.credit,
          ),
          target: Target(type: game.target!.type, value: game.target!.value),
        ),
      )
      .toList();
}
