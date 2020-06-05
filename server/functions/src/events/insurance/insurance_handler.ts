import { InsuranceEvent } from './insurance_event';
import { Game } from '../../models/domain/game/game';
import { InsuranceAssetEntity, InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { Account } from '../../models/domain/account';
import { UserEntity } from '../../models/domain/user';
import { Asset } from '../../models/domain/asset';
import produce from 'immer';

type Event = InsuranceEvent.Event;
type Action = InsuranceEvent.PlayerAction;

interface ActionResult {
  readonly newAssets: Asset[];
  readonly newAccountBalance: number;
}

interface ActionParameters {
  readonly cost: number;
  readonly value: number;
  readonly movesLeft: number;
  readonly insuranceType: InsuranceAssetEntity.InsuranceType;
  readonly userAccount: Account;
  readonly event: Event;
  readonly assets: Asset[];
}

export class InsuranceHandler {
  get gameEventType(): string {
    return InsuranceEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      InsuranceEvent.validate(event);
      InsuranceEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { cost, value, movesLeft, insuranceType } = event.data;

    const userAccount = game.accounts[userId];

    const assets = game.possessions[userId].assets;

    const actionParameters: ActionParameters = {
      cost,
      value,
      movesLeft,
      insuranceType,
      userAccount,
      event,
      assets,
    };

    const actionResult = this.applyAction(actionParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = actionResult.newAccountBalance;
      draft.possessions[userId].assets = actionResult.newAssets;
    });

    return updatedGame;
  }

  applyAction(actionParameters: ActionParameters): ActionResult {
    const { cost, value, movesLeft, insuranceType, userAccount, event, assets } = actionParameters;

    // TODO implement credit and test
    const isEnoughMoney = userAccount.cash >= cost;
    if (!isEnoughMoney) {
      throw new Error('Not enough money');
    }

    const newAccountBalance = userAccount.cash - cost;

    const insuranceAsset: InsuranceAsset = {
      id: event.id,
      name: event.name,
      type: 'insurance',
      cost,
      value,
      movesLeft,
      insuranceType,
    };

    const newAssets = assets.slice();

    newAssets.push(insuranceAsset);

    const actionResult: ActionResult = {
      newAccountBalance,
      newAssets,
    };

    return actionResult;
  }
}
