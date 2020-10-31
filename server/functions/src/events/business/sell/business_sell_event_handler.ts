import produce from 'immer';

import { PlayerActionHandler } from '../../../core/domain/player_action_handler';
import { Asset } from '../../../models/domain/asset';
import { Game } from '../../../models/domain/game/game';
import { Account } from '../../../models/domain/account';
import { Liability } from '../../../models/domain/liability';
import { BusinessSellEvent } from './business_sell_event';
import { UserEntity } from '../../../models/domain/user/user';

type Event = BusinessSellEvent.Event;
type Action = BusinessSellEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
  readonly newUserCreditValue: number;
  readonly newAssets: Asset[];
  readonly newLiabilities: Liability[];
}

interface ActionSellParameters {
  readonly userAccount: Account;
  readonly assets: Asset[];
  readonly theSameBusinessIndex: number;
  readonly liabilities: Liability[];
  readonly theSameLiabilityIndex: number;
  readonly currentPrice: number;
}

export class BusinessSellEventHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return BusinessSellEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      BusinessSellEvent.validate(event);
      BusinessSellEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { businessId, currentPrice } = event.data;

    const { action: businessAction } = action;

    if (businessAction !== 'sell') {
      throw new Error(
        'Error action type when dispatching ' +
          businessAction +
          ' in ' +
          BusinessSellEventHandler.name
      );
    }

    const assets = game.possessions[userId].assets;
    const theSameBusinessIndex = this.getExistingBusiness(assets, businessId);

    const liabilities = game.possessions[userId].liabilities;
    const theSameLiabilityIndex = this.getExistingLiability(liabilities, businessId);

    const userAccount = game.accounts[userId];

    const actionSellParameters: ActionSellParameters = {
      userAccount,
      assets,
      theSameBusinessIndex,
      currentPrice,
      liabilities,
      theSameLiabilityIndex,
    };

    const actionResult = await this.applySellAction(actionSellParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].credit = actionResult.newUserCreditValue;
      draft.accounts[userId].cash = actionResult.newAccountBalance;
      draft.possessions[userId].assets = actionResult.newAssets;
      draft.possessions[userId].liabilities = actionResult.newLiabilities;
    });

    return updatedGame;
  }

  getExistingBusiness(assets: Asset[], businessId: string): number {
    const theSameBusinessIndex = assets.findIndex((business) => {
      return business.id === businessId;
    });

    if (theSameBusinessIndex < 0) {
      throw new Error('Can not find business with id ' + businessId);
    }

    return theSameBusinessIndex;
  }

  getExistingLiability(liabilities: Liability[], businessId: string): number {
    const theSameLiabilityIndex = liabilities.findIndex((liability) => {
      return liability.id === businessId;
    });

    if (theSameLiabilityIndex < 0) {
      throw new Error('Can not find liability with id ' + businessId);
    }

    return theSameLiabilityIndex;
  }

  async applySellAction(actionParameters: ActionSellParameters): Promise<ActionResult> {
    const {
      userAccount,
      assets,
      theSameBusinessIndex,
      currentPrice,
      liabilities,
      theSameLiabilityIndex,
    } = actionParameters;

    //TODO implement credit and write tests
    const canCredit = false;
    const businessLiability = liabilities[theSameLiabilityIndex];

    let newAccountBalance;
    let newUserCreditValue;
    const difference = currentPrice - businessLiability.value;
    const differencePositive = Math.max(difference, -difference);
    if (difference >= 0) {
      newAccountBalance = userAccount.cash + difference;
      newUserCreditValue = userAccount.credit;
    } else if (difference < 0 && userAccount.cash >= differencePositive) {
      newAccountBalance = userAccount.cash - differencePositive;
      newUserCreditValue = userAccount.credit;
    } else if (difference < 0 && canCredit) {
      const emptyBalance = 0;
      newAccountBalance = emptyBalance;

      const currentUserAccountCash = userAccount.cash;
      const addToCredit = differencePositive - currentUserAccountCash;
      newUserCreditValue = userAccount.credit + addToCredit;
    } else {
      throw new Error(
        'Unexpected behaviour on ' + BusinessSellEventHandler.name + 'when counting sum'
      );
    }

    const newAssets = this.removeFromAssets(theSameBusinessIndex, assets);
    const newLiabilities = this.removeFromLiabilties(theSameLiabilityIndex, liabilities);

    const actionResult: ActionResult = {
      newAccountBalance,
      newUserCreditValue,
      newAssets,
      newLiabilities,
    };

    return actionResult;
  }

  removeFromAssets(theSameBusinessIndex: number, assets: Asset[]): Asset[] {
    const newAssets = (assets || []).slice();
    const countItemsToRemove = 1;
    newAssets.splice(theSameBusinessIndex, countItemsToRemove);

    return newAssets;
  }

  removeFromLiabilties(theSameLiabilityIndex: number, liabilities: Liability[]): Liability[] {
    const newLiabilities = (liabilities || []).slice();
    const countItemsToRemove = 1;
    newLiabilities.splice(theSameLiabilityIndex, countItemsToRemove);

    return newLiabilities;
  }
}
