import { MonthlyExpenseEvent } from './monthly_expense_event';
import { Expense } from '../../models/domain/expense';
import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { UserEntity } from '../../models/domain/user/user';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';

type Event = MonthlyExpenseEvent.Event;
type Action = MonthlyExpenseEvent.PlayerAction;

interface ActionResult {
  readonly newExpenses: Expense[];
}

interface ActionParameters {
  readonly expenses: Expense[];
  readonly monthlyPayment: number;
  readonly expenseName: string;
  readonly expenseId: string;
}

export class MonthlyExpenseEventHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return MonthlyExpenseEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      MonthlyExpenseEvent.validate(event);
      MonthlyExpenseEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { monthlyPayment, expenseName } = event.data;

    const expenses = game.possessions[userId].expenses;

    const actionChildBornParameters: ActionParameters = {
      expenses,
      monthlyPayment,
      expenseName,
      expenseId: event.id,
    };

    const actionResult = await this.applyAction(actionChildBornParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.possessions[userId].expenses = actionResult.newExpenses;
    });

    return updatedGame;
  }

  async applyAction(actionParameters: ActionParameters): Promise<ActionResult> {
    const { expenses, monthlyPayment, expenseName, expenseId } = actionParameters;

    const newExpense: Expense = {
      id: expenseId,
      name: expenseName,
      value: monthlyPayment,
    };
    const newExpenses = (expenses || []).slice();
    newExpenses.push(newExpense);

    const actionResult: ActionResult = {
      newExpenses,
    };

    return actionResult;
  }
}
