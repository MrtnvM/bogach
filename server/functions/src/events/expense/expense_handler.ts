import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { Game } from '../../models/domain/game/game';
import { Account } from '../../models/domain/account';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user';
import { ExpenseEvent } from './expense_event';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';

type Event = ExpenseEvent.Event;
type Action = ExpenseEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
}

interface ActionParameters {
  readonly userAccount: Account;
  readonly expenseToPay: number;
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
    const { expense, insuranceType } = event.data;

    const userAccount = game.accounts[userId];

    const assets = game.possessions[userId].assets;

    var insurancesValue = 0;
    if (insuranceType !== null) {
      insurancesValue = assets
        .filter((asset) => asset.type === 'insurance')
        .map((asset) => asset as InsuranceAsset)
        .filter((insurance) => insurance.insuranceType === insuranceType)
        .reduce((prev, curr) => prev + curr.value, 0);
    }

    var expenseToPay = expense - insurancesValue;
    if (expenseToPay < 0) {
      expenseToPay = 0;
    }

    const actionParameters: ActionParameters = {
      userAccount,
      expenseToPay,
    };

    const actionResult = this.applyAction(actionParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = actionResult.newAccountBalance;
    });

    return updatedGame;
  }

  applyAction(actionParameters: ActionParameters): ActionResult {
    const { userAccount, expenseToPay } = actionParameters;

    const newAccountBalance = userAccount.cash - expenseToPay;

    const actionResult: ActionResult = {
      newAccountBalance,
    };

    return actionResult;
  }
}
