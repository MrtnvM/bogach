import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { Game } from '../../models/domain/game/game';
import { Account } from '../../models/domain/account';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user';
import { ExpenseEvent } from './expense_event';

type Event = ExpenseEvent.Event;
type Action = ExpenseEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
}

interface ActionParameters {
  readonly userAccount: Account;
  readonly expense: number;
}

export class ExpenseHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return ExpenseEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      ExpenseEvent.validate(event);
      ExpenseEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { expense } = event.data;

    const userAccount = game.accounts[userId];

    const actionParameters: ActionParameters = {
      userAccount,
      expense,
    };

    const actionResult = this.applyAction(actionParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = actionResult.newAccountBalance;
    });

    return updatedGame;
  }

  applyAction(actionParameters: ActionParameters): ActionResult {
    const { userAccount, expense } = actionParameters;

    const newAccountBalance = userAccount.cash - expense;

    const actionResult: ActionResult = {
      newAccountBalance,
    };

    return actionResult;
  }
}
