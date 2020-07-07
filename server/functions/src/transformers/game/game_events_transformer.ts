import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { GameEvent } from '../../models/domain/game/game_event';
import { GameEventGenerator } from '../../generators/game_event_generator';
import { DebentureGenerateRule } from '../../generators/rules/debenture_generate_rule';
import { IncomeGenerateRule } from '../../generators/rules/income_generate_rule';
import { ExpenseGenerateRule } from '../../generators/rules/expense_generate_rule';
import { InsuranceGenerateRule } from '../../generators/rules/insurance_generate_rule';
import { MonthlyExpenseGenerateRule } from '../../generators/rules/monthly_expense_generate_rule';
import { StockGenerateRule } from '../../generators/rules/stock_generate_rule';
import { RealEstateBuyRule } from '../../generators/rules/real_estate_buy_generate_rule';

export class GameEventsTransformer extends GameTransformer {
  constructor(private force: boolean = false) {
    super();
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const shouldGenerateEvents = isMoveCompleted || this.force;
    const gameEvents = shouldGenerateEvents ? this.generateGameEvents(game) : game.currentEvents;

    return produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });
  }

  private generateGameEvents(game: Game): GameEvent[] {
    const gameEventGenerator = new GameEventGenerator({
      rules: [
        new DebentureGenerateRule(),
        new IncomeGenerateRule(),
        new ExpenseGenerateRule(),
        new InsuranceGenerateRule(),
        new MonthlyExpenseGenerateRule(),
        new StockGenerateRule(),
        new RealEstateBuyRule(),
      ],
    });

    const gameEvents = gameEventGenerator.generateEvents(game);
    return gameEvents;
  }
}
