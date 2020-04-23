import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { AssetEntity, Asset } from '../../models/domain/asset';
import { Strings } from '../../resources/strings';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';
import { GameContext } from '../../models/domain/game/game_context';
import { GameProvider } from '../../providers/game_provider';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';
import { StockPriceChangedEvent } from './stock_price_changed_event';
import { StockAsset } from '../../models/domain/assets/stock_asset';
import { Account } from '../../models/domain/account';

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
  constructor(private gameProvider: GameProvider) {
    super();
  }

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

  async handle(event: Event, action: Action, context: GameContext): Promise<void> {
    const { gameId, userId } = context;
    const game = await this.gameProvider.getGame(gameId);

    const { currentPrice, fairPrice, availableCount } = event.data;
    const { count: actionCount, action: stockAction } = action;

    const assets = game.possessions[userId].assets;
    const stockAssets = AssetEntity.getStocks(assets);
    const stockName = event.name;

    const theSameStock = stockAssets.find((d) => {
      return d.name === stockName && d.fairPrice === fairPrice;
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
    const actionResult = await this.applyAction(actionParameters, stockAction);

    let newAssets: Asset[];
    if (theSameStock) {
      newAssets = this.updateAssets(actionResult, theSameStock, assets);
    } else {
      newAssets = this.addNewItemToAssets(actionResult, assets, fairPrice);
    }

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = actionResult.newAccountBalance;
      draft.possessions[userId].assets = newAssets;
    });

    await this.gameProvider.updateGame(updatedGame);
  }

  async applyAction(actionParameters: ActionParameters, action: BuySellAction) {
    if (action === 'buy') {
      return this.applyBuyAction(actionParameters);
    } else if (action === 'sell') {
      return this.applySellAction(actionParameters);
    } else {
      throw new Error('Unknown action with stocks');
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
      throw new Error('Not enough stocks available');
    }

    const newStockCount = countInPortfolio + actionCount;
    const newAccountBalance = userAccount.cash - totalPrice;

    const pricesDifference = currentPrice - currentAveragePrice;
    const commonCount = countInPortfolio + actionCount;
    const priceDifferenceStep = pricesDifference / commonCount;

    const newPriceOffset = priceDifferenceStep * actionCount;
    let newAveragePrice = currentAveragePrice + newPriceOffset;

    const actionResult: ActionResult = {
      newStockCount,
      newAccountBalance,
      newAveragePrice,
    };

    return actionResult;
  }

  async applySellAction(actionParameters: ActionParameters): Promise<ActionResult> {
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
    const index = assets.findIndex((d) => d.id === newStock.id);

    if (index >= 0) {
      newAssets[index] = newStock;
    }

    if (newStock.countInPortfolio === 0) {
      newAssets = assets.filter((d) => d.id !== newStock.id);
    }

    return newAssets;
  }

  addNewItemToAssets(actionResult: ActionResult, assets: Asset[], fairPrice: number): Asset[] {
    let newAssets = assets.slice();

    const newStock: StockAsset = {
      fairPrice,
      averagePrice: actionResult.newAveragePrice,
      countInPortfolio: actionResult.newStockCount,
      name: Strings.stocks(),
      type: 'stock',
    };

    newAssets.push(newStock);

    return newAssets;
  }
}
