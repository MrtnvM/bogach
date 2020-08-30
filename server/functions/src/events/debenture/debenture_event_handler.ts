import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { DebentureEvent } from './debenture_event';
import { AssetEntity, Asset } from '../../models/domain/asset';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';
import { Game } from '../../models/domain/game/game';
import { Account } from '../../models/domain/account';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user';
import { DomainErrors } from '../../core/exceptions/domain/domain_errors';

type Event = DebentureEvent.Event;
type Action = DebentureEvent.PlayerAction;

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

export class DebentureEventHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return DebentureEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      DebentureEvent.validate(event);
      DebentureEvent.validateAction(action);
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

    const theSameDebenture = debetureAssets.find((debenture) => {
      return this.isDebentureTheSame(debenture, debentureName, nominal, profitabilityPercent);
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
    }

    if (action === 'sell') {
      return this.applySellAction(actionParameters);
    }

    throw new Error('Unknown action with debentures');
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
      throw DomainErrors.notEnoughCash;
    }

    const isEnoughCountAvailable = availableCount >= actionCount;
    if (!isEnoughCountAvailable) {
      throw DomainErrors.notEnoughDebenturesOnMarket;
    }

    const newDebentureCount = countInPortfolio + actionCount;
    const newAccountBalance = userAccount.cash - totalPrice;

    const pricesDifference = currentPrice - currentAveragePrice;
    const commonCount = countInPortfolio + actionCount;
    const priceDifferenceStep = pricesDifference / commonCount;

    const newPriceOffset = priceDifferenceStep * actionCount;
    const newAveragePrice = currentAveragePrice + newPriceOffset;

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
      currentAveragePrice,
      totalPrice,
    } = actionParameters;

    if (countInPortfolio < actionCount) {
      throw DomainErrors.notEnoughDebenturesInPortfolio;
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
    const index = assets.indexOf(theSameDebenture);

    if (index >= 0) {
      newAssets[index] = newDebenture;
    }

    if (newDebenture.count === 0) {
      newAssets = newAssets.filter((asset) => {
        if ((asset as DebentureAsset) === undefined) {
          return true;
        }

        const isTheSame = this.isDebentureTheSame(
          asset as DebentureAsset,
          newDebenture.name,
          newDebenture.nominal,
          newDebenture.profitabilityPercent
        );

        return !isTheSame;
      });
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
    const newAssets = assets.slice();

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

  isDebentureTheSame(
    debenture: DebentureAsset,
    debentureName: String,
    nominal: number,
    profitabilityPercent: number
  ): boolean {
    return (
      debenture.name === debentureName &&
      debenture.profitabilityPercent === profitabilityPercent &&
      debenture.nominal === nominal
    );
  }
}
