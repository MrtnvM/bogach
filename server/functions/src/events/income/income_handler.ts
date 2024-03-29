import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { Game } from '../../models/domain/game/game';
import { Account } from '../../models/domain/account';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user/user';
import { IncomeEvent } from './income_event';

type Event = IncomeEvent.Event;
type Action = IncomeEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
}

interface ActionParameters {
  readonly userAccount: Account;
  readonly income: number;
}

export class IncomeHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return IncomeEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      IncomeEvent.validate(event);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { income } = event.data;

    const userAccount = game.participants[userId].account;

    const actionParameters: ActionParameters = {
      userAccount,
      income,
    };

    const actionResult = this.applyAction(actionParameters);

    const updatedGame: Game = produce(game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = actionResult.newAccountBalance;
    });

    return updatedGame;
  }

  applyAction(actionParameters: ActionParameters): ActionResult {
    const { userAccount, income } = actionParameters;

    const newAccountBalance = userAccount.cash + income;

    const actionResult: ActionResult = {
      newAccountBalance,
    };

    return actionResult;
  }
}
