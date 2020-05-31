import { ChildBornEvent } from './child_born_event';
import { Expense } from '../../models/domain/expense';
import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { UserEntity } from '../../models/domain/user';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';

type Event = ChildBornEvent.Event;
type Action = ChildBornEvent.PlayerAction;

interface ActionResult {
  readonly newExpenses: Expense[];
}

interface ActionParameters {
  readonly expenses: Expense[];
  readonly monthlyPayment: number;
}

export class ChildBornEventHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return ChildBornEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      ChildBornEvent.validate(event);
      ChildBornEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { monthlyPayment } = event.data;

    const expenses = game.possessions[userId].expenses;

    const actionChildBornParameters: ActionParameters = {
      expenses,
      monthlyPayment,
    };

    const actionResult = await this.applyAction(actionChildBornParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.possessions[userId].expenses = actionResult.newExpenses;
    });

    return updatedGame;
  }

  async applyAction(actionParameters: ActionParameters): Promise<ActionResult> {
    const { expenses, monthlyPayment } = actionParameters;

    const currentChildren = expenses.filter((e) => e.type === 'child');
    const currentChildrenCount = currentChildren.length;
    const nextChildNumber = currentChildrenCount + 1;
    const newExpense: Expense = {
      name: 'Ребёнок ' + nextChildNumber,
      type: 'child',
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
