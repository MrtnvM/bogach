import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { AssetEntity, Asset } from '../../models/domain/asset';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';
import { StockPriceChangedEvent } from './stock_price_changed_event';
import { StockAsset } from '../../models/domain/assets/stock_asset';
import { Account } from '../../models/domain/account';
import { UserEntity } from '../../models/domain/user';

type Event = StockPriceChangedEvent.Event;
type Action = StockPriceChangedEvent.PlayerAction;

interface ActionResult {
  readonly newStockCount: number;
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

export class StockPriceChangedHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return StockPriceChangedEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      StockPriceChangedEvent.validate(event);
      StockPriceChangedEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { currentPrice, fairPrice, availableCount } = event.data;
    const { count: actionCount, action: stockAction } = action;

    const assets = game.possessions[userId].assets;
    const stockAssets = AssetEntity.getStocks(assets);
    const stockName = event.name;

    const theSameStock = stockAssets.find((d) => {
      return d.name === stockName;
    });

    const countInPortfolio = theSameStock?.countInPortfolio || 0;
    const currentAveragePrice = theSameStock?.averagePrice || 0;

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
    const actionResult = this.applyAction(actionParameters, stockAction);

    const newAssets = theSameStock
      ? this.updateAssets(actionResult, theSameStock, assets)
      : this.addNewItemToAssets(actionResult, assets, fairPrice, stockName);

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = actionResult.newAccountBalance;
      draft.possessions[userId].assets = newAssets;
    });

    return updatedGame;
  }

  applyAction(actionParameters: ActionParameters, action: BuySellAction) {
    if (action === 'buy') {
      return this.applyBuyAction(actionParameters);
    }

    if (action === 'sell') {
      return this.applySellAction(actionParameters);
    }

    throw new Error('Unknown action with stocks');
  }

  applyBuyAction(actionParameters: ActionParameters): ActionResult {
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
      throw new Error('Not enough stocks available');
    }

    const newStockCount = countInPortfolio + actionCount;
    const newAccountBalance = userAccount.cash - totalPrice;

    const pricesDifference = currentPrice - currentAveragePrice;
    const commonCount = countInPortfolio + actionCount;
    const priceDifferenceStep = pricesDifference / commonCount;

    const newPriceOffset = priceDifferenceStep * actionCount;
    const newAveragePrice = currentAveragePrice + newPriceOffset;

    const actionResult: ActionResult = {
      newStockCount,
      newAccountBalance,
      newAveragePrice,
    };

    return actionResult;
  }

  applySellAction(actionParameters: ActionParameters): ActionResult {
    const isEnoughCountAvailable = actionParameters.availableCount >= actionParameters.actionCount;
    if (!isEnoughCountAvailable) {
      throw new Error('Not enough stocks available');
    }

    if (actionParameters.countInPortfolio < actionParameters.actionCount) {
      throw new Error('Not enough stocks in portfolio');
    }

    const newStockCount = actionParameters.countInPortfolio - actionParameters.actionCount;
    const newAccountBalance = actionParameters.userAccount.cash + actionParameters.totalPrice;
    const newAveragePrice = actionParameters.currentAveragePrice;

    const actionResult: ActionResult = {
      newStockCount,
      newAccountBalance,
      newAveragePrice,
    };

    return actionResult;
  }

  updateAssets(actionResult: ActionResult, theSameStock: StockAsset, assets: Asset[]): Asset[] {
    let newAssets = assets.slice();

    const newStock = {
      ...theSameStock,
      countInPortfolio: actionResult.newStockCount,
      averagePrice: actionResult.newAveragePrice,
    };
    const index = assets.findIndex((d) => d.name === newStock.name);

    if (index >= 0) {
      newAssets[index] = newStock;
    }

    if (newStock.countInPortfolio === 0) {
      newAssets = assets.filter((d) => d.name !== newStock.name);
    }

    return newAssets;
  }

  addNewItemToAssets(
    actionResult: ActionResult,
    assets: Asset[],
    fairPrice: number,
    stockName: string
  ): Asset[] {
    const newAssets = assets.slice();

    const newStock: StockAsset = {
      fairPrice,
      averagePrice: actionResult.newAveragePrice,
      countInPortfolio: actionResult.newStockCount,
      name: stockName,
      type: 'stock',
    };

    newAssets.push(newStock);

    return newAssets;
  }
}
