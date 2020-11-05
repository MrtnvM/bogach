import { InsuranceEvent } from './insurance_event';
import { Game } from '../../models/domain/game/game';
import { InsuranceAssetEntity, InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { Account } from '../../models/domain/account';
import { UserEntity } from '../../models/domain/user/user';
import { Asset } from '../../models/domain/asset';
import produce from 'immer';
import { DomainErrors } from '../../core/exceptions/domain/domain_errors';

type Event = InsuranceEvent.Event;
type Action = InsuranceEvent.PlayerAction;

interface ActionResult {
  readonly newAssets: Asset[];
  readonly newAccountBalance: number;
}

interface ActionParameters {
  readonly cost: number;
  readonly value: number;
  readonly duration: number;
  readonly fromMonth: number;
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
    const { cost, value, duration, insuranceType } = event.data;

    const userAccount = game.accounts[userId];
    const currentMonth = game.state.monthNumber;

    const assets = game.possessions[userId].assets;

    const actionParameters: ActionParameters = {
      cost,
      value,
      duration,
      fromMonth: currentMonth,
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
    const {
      cost,
      value,
      fromMonth,
      duration,
      insuranceType,
      userAccount,
      event,
      assets,
    } = actionParameters;

    // TODO implement credit and test
    const isEnoughMoney = userAccount.cash >= cost;
    if (!isEnoughMoney) {
      throw DomainErrors.notEnoughCash;
    }

    const newAccountBalance = userAccount.cash - cost;

    const insuranceAsset: InsuranceAsset = {
      id: event.id,
      name: event.name,
      type: 'insurance',
      cost,
      value,
      fromMonth,
      duration,
      insuranceType,
    };

    const newAssets = (assets || []).slice();

    newAssets.push(insuranceAsset);

    const actionResult: ActionResult = {
      newAccountBalance,
      newAssets,
    };

    return actionResult;
  }
}
