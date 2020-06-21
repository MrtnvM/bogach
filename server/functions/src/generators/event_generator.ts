import { GameEvent } from '../models/domain/game/game_event';
import { Rule } from './generator_rule';
import * as random from 'random';
import { DebentureGenerateRule } from './rules/debenture_generate_rule';
import { IncomeGenerateRule } from './rules/income_generate_rule';
import { ExpenseGenerateRule } from './rules/expense_generate_rule';
import { InsuranceGenerateRule } from './rules/insurance_generate_rule';
import { MonthlyExpenseGenerateRule } from './rules/monthly_expense_generate_rule';
import { StockGenerateRule } from './rules/stock_generate_rule';

export namespace GameEventGenerator {
  const rules: Rule<any>[] = [
    new DebentureGenerateRule(),
    new IncomeGenerateRule(),
    new ExpenseGenerateRule(),
    new InsuranceGenerateRule(),
    new MonthlyExpenseGenerateRule(),
    new StockGenerateRule(),
  ];
  const allProbability: number = rules.reduce((prev, cur) => prev + cur.getPercentage(), 0);

  export const generateNextEvent = (events: GameEvent[]): GameEvent => {
    let event: GameEvent | null = null!;

    while (event === null) {
      event = generateEvent(events);
    }

    return event;
  };

  const generateEvent = (events: GameEvent[]): GameEvent | null => {
    const rule: Rule<any> = findRule(events);
    const distanceDoable = isDistanceDoable(events, rule);

    if (distanceDoable && rule.canGenerate(events)) {
      return rule.generate();
    }

    return null;
  };

  const findRule = (events: GameEvent[]): Rule<any> => {
    let randomNumber: number = random.int(0, allProbability);

    for (let rule of rules) {
      randomNumber -= rule.getPercentage();

      if (randomNumber <= 0) {
        return rule;
      }
    }

    // Won't be called in the correct implementation
    return rules[0];
  };

  const isDistanceDoable = (events: GameEvent[], rule: Rule<any>): boolean => {
    const minDuration: number = rule.getMinDuration();
    const start: number = events.length - minDuration < 0 ? 0 : events.length - minDuration;
    const end: number = events.length;
    return events.slice(start, end).find((item) => item.type === rule.getType()) !== undefined;
  };
}
