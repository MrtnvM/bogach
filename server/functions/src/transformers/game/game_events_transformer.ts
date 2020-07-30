import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { GameEvent } from '../../models/domain/game/game_event';
import { GameEventGenerator } from '../../generators/game_event_generator';
import { IncomeGenerateRule } from '../../generators/rules/income_generate_rule';
import { ExpenseGenerateRule } from '../../generators/rules/expense_generate_rule';
import { GameLevels } from '../../game_levels/game_levels';
import { IncomeGeneratorConfig } from '../../events/income/income_generator_config';
import { ExpenseGeneratorConfig } from '../../events/expense/expense_generator_config';
import { InsuranceGeneratorConfig } from '../../events/insurance/insurance_generator_config';
import { DebentureGenerateRule } from '../../generators/rules/debenture_generate_rule';
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
    const levelId = game.config.level;
    const level = levelId && GameLevels.levelsMap[levelId];

    if (level) {
      const levelGameEvents = level.levelEventConfig.events[game.state.monthNumber - 1];
      return levelGameEvents;
    }

    const gameEventGenerator = new GameEventGenerator({
      rules: this.getDefaultRules(),
    });

    const gameEvents = gameEventGenerator.generateEvents(game);
    return gameEvents;
  }

  private getDefaultRules() {
    const incomeRule = new IncomeGenerateRule(
      {
        probabilityLevel: 4,
        minDistanceBetweenEvents: 3,
      },
      IncomeGeneratorConfig.allIncomes
    );

    const expenseRule = new ExpenseGenerateRule(
      {
        probabilityLevel: 4,
        minDistanceBetweenEvents: 2,
      },
      ExpenseGeneratorConfig.allExpenses
    );

    const healthInsuranceRule = new InsuranceGenerateRule(
      { probabilityLevel: 5, minDistanceBetweenEvents: 6 },
      InsuranceGeneratorConfig.healthInsurance()
    );

    const propertyInsuranceRule = new InsuranceGenerateRule(
      { probabilityLevel: 5, minDistanceBetweenEvents: 6 },
      InsuranceGeneratorConfig.propertyInsurance()
    );

    const debentureRule = new DebentureGenerateRule();
    const monthlyExpenseRule = new MonthlyExpenseGenerateRule();
    const stockRule = new StockGenerateRule();
    const realEstateRule = new RealEstateBuyRule();

    return [
      incomeRule,
      expenseRule,
      healthInsuranceRule,
      propertyInsuranceRule,
      debentureRule,
      monthlyExpenseRule,
      stockRule,
      realEstateRule,
    ];
  }
}
