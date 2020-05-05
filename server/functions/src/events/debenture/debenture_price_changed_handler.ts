import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { DebenturePriceChangedEvent } from './debenture_price_changed_event';
import { AssetEntity, Asset } from '../../models/domain/asset';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';
import { Game } from '../../models/domain/game/game';
import { Account } from '../../models/domain/account';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user';

type Event = DebenturePriceChangedEvent.Event;
type Action = DebenturePriceChangedEvent.PlayerAction;

interface ActionResult {
  readonly newDebentureCount: number;
  readonly newAccountBalance: number;
  readonly newAveragePrice: number;
}

interface ActionParameters {
  readonly userAccount: Account;
  readonly countInPortfolio: number;
  readonly actionCount: number;
  readonly availableCount: number;
  readonly currentPrice: number;
  readonly currentAveragePrice: number;
  readonly totalPrice: number;
}

export class DebenturePriceChangedHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return DebenturePriceChangedEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      DebenturePriceChangedEvent.validate(event);
      DebenturePriceChangedEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { currentPrice, nominal, profitabilityPercent, availableCount } = event.data;
    const { count: actionCount, action: debentureAction } = action;

    const assets = game.possessions[userId].assets;
    const debetureAssets = AssetEntity.getDebentures(assets);

    const debentureName = event.name;

    const theSameDebenture = debetureAssets.find((d) => {
      return (
        d.name === debentureName &&
        d.nominal === nominal &&
        d.profitabilityPercent === profitabilityPercent
      );
    });

    const countInPortfolio = theSameDebenture?.count || 0;
    const currentAveragePrice = theSameDebenture?.averagePrice || 0;

    const userAccount = game.accounts[userId];
    const totalPrice = currentPrice * actionCount;

    const actionParameters: ActionParameters = {
      userAccount,
      countInPortfolio,
      actionCount,
      availableCount,
      currentPrice,
      currentAveragePrice,
      totalPrice,
    };

    const actionResult = await this.applyAction(actionParameters, debentureAction);

    let newAssets: Asset[];
    if (theSameDebenture) {
      newAssets = this.updateAssets(actionResult, theSameDebenture, assets);
    } else {
      newAssets = this.addNewItemToAssets(
        actionResult,
        assets,
        nominal,
        profitabilityPercent,
        debentureName
      );
    }

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = actionResult.newAccountBalance;
      draft.possessions[userId].assets = newAssets;
    });

    return updatedGame;
  }

  async applyAction(actionParameters: ActionParameters, action: BuySellAction) {
    if (action === 'buy') {
      return this.applyBuyAction(actionParameters);
    } else if (action === 'sell') {
      return this.applySellAction(actionParameters);
    } else {
      throw new Error('Unknown action with debentures');
    }
  }

  async applyBuyAction(actionParameters: ActionParameters): Promise<ActionResult> {
    const {
      userAccount,
      countInPortfolio,
      actionCount,
      availableCount,
      currentPrice,
      currentAveragePrice,
      totalPrice,
    } = actionParameters;

    const isEnoughMoney = userAccount.cash >= totalPrice;
    if (!isEnoughMoney) {
      throw new Error('Not enough money');
    }

    const isEnoughCountAvailable = availableCount >= actionCount;
    if (!isEnoughCountAvailable) {
      throw new Error('Not enough debentures available');
    }

    const newDebentureCount = countInPortfolio + actionCount;
    const newAccountBalance = userAccount.cash - totalPrice;

    const pricesDifference = currentPrice - currentAveragePrice;
    const commonCount = countInPortfolio + actionCount;
    const priceDifferenceStep = pricesDifference / commonCount;

    const newPriceOffset = priceDifferenceStep * actionCount;
    let newAveragePrice = currentAveragePrice + newPriceOffset;

    const actionResult: ActionResult = {
      newDebentureCount,
      newAccountBalance,
      newAveragePrice,
    };

    return actionResult;
  }

  async applySellAction(actionParameters: ActionParameters): Promise<ActionResult> {
    const {
      userAccount,
      countInPortfolio,
      actionCount,
      availableCount,
      currentAveragePrice,
      totalPrice,
    } = actionParameters;

    const isEnoughCountAvailable = availableCount >= actionCount;
    if (!isEnoughCountAvailable) {
      throw new Error('Not enough debentures available');
    }

    if (countInPortfolio < actionCount) {
      throw new Error('Not enough debentures in portfolio');
    }

    const newDebentureCount = countInPortfolio - actionCount;
    const newAccountBalance = userAccount.cash + totalPrice;
    const newAveragePrice = currentAveragePrice;

    const actionResult: ActionResult = {
      newDebentureCount,
      newAccountBalance,
      newAveragePrice,
    };

    return actionResult;
  }

  updateAssets(
    actionResult: ActionResult,
    theSameDebenture: DebentureAsset,
    assets: Asset[]
  ): Asset[] {
    const newDebenture = {
      ...theSameDebenture,
      count: actionResult.newDebentureCount,
      averagePrice: actionResult.newAveragePrice,
    };
    let newAssets = assets.slice();
    const index = newAssets.findIndex((d) => d.id === newDebenture.id);

    if (index >= 0) {
      newAssets[index] = newDebenture;
    }

    if (newDebenture.count === 0) {
      newAssets = newAssets.filter((d) => d.id !== newDebenture.id);
    }

    return newAssets;
  }

  addNewItemToAssets(
    actionResult: ActionResult,
    assets: Asset[],
    nominal: number,
    profitabilityPercent: number,
    debentureName: string
  ): Asset[] {
    let newAssets = assets.slice();

    const newDebenture: DebentureAsset = {
      averagePrice: actionResult.newAveragePrice,
      nominal,
      profitabilityPercent,
      count: actionResult.newDebentureCount,
      name: debentureName,
      type: 'debenture',
    };

    newAssets.push(newDebenture);

    return newAssets;
  }
}
