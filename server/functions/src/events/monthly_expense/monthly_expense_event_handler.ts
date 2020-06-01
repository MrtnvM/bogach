import { MonthlyExpenseEvent } from './monthly_expense_event';
import { Expense, ExpenseEntity } from '../../models/domain/expense';
import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { UserEntity } from '../../models/domain/user';
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
  readonly expenseType: ExpenseEntity.Type;
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
    const { monthlyPayment, expenseType, expenseName } = event.data;

    const expenses = game.possessions[userId].expenses;

    const actionChildBornParameters: ActionParameters = {
      expenses,
      monthlyPayment,
      expenseName,
      expenseType,
    };

    const actionResult = await this.applyAction(actionChildBornParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.possessions[userId].expenses = actionResult.newExpenses;
    });

    return updatedGame;
  }

  async applyAction(actionParameters: ActionParameters): Promise<ActionResult> {
    const { expenses, monthlyPayment, expenseType, expenseName } = actionParameters;

    const newExpense: Expense = {
      name: expenseName,
      type: expenseType,
      value: monthlyPayment,
    };
    const newExpenses = expenses.slice();
    newExpenses.push(newExpense);

    const actionResult: ActionResult = {
      newExpenses,
    };

    return actionResult;
  }
}
