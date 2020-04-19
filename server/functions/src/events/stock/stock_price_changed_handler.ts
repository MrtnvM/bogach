import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { AssetEntity } from '../../models/domain/asset';
import { Strings } from '../../resources/strings';
import { UserEntity } from '../../models/domain/user';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';
import { GameContext } from '../../models/domain/game/game_context';
import { GameProvider } from '../../providers/game_provider';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';
import { StockPriceChangedEvent } from './stock_price_changed_event';
import { StockAsset } from '../../models/domain/assets/stock_asset';

type Event = StockPriceChangedEvent.Event;
type Action = StockPriceChangedEvent.PlayerAction;

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

    const { currentPrice, fairPrice, maxCount } = event.data;
    const { count, action: stockAction } = action;

    const assets = game.possessions[userId].assets;
    const stockAssets = AssetEntity.getStocks(assets);

    const theSameStock = stockAssets.find((d) => {
      return d.name === name && d.fairPrice === fairPrice;
    });

    const currentStockCount = theSameStock?.countInPortfolio || 0;
    const currentAveragePrice = theSameStock?.averagePrice || currentPrice;

    const { newStockCount, newAccountBalance, newAveragePrice } = await this.applyAction({
      game,
      stockAction,
      currentStockCount,
      userId,
      count,
      maxCount,
      currentPrice,
      currentAveragePrice,
    });

    let newAssets = assets.slice();

    if (theSameStock) {
      const newStock = { ...theSameStock, count: newStockCount, averagePrice: newAveragePrice };
      const index = assets.findIndex((d) => d.id === newStock.id);

      if (index >= 0) {
        newAssets[index] = newStock;
      }

      if (newStock.count === 0) {
        newAssets = assets.filter((d) => d.id !== newStock.id);
      }
    } else {
      const newStock = {
        currentPrice,
        fairPrice,
        averagePrice: newAveragePrice,
        countInPortfolio: newStockCount,
        name: Strings.stocks(),
        type: 'stock',
      };

      newAssets.push(newStock as StockAsset);
    }

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = newAccountBalance;
      draft.possessions[userId].assets = newAssets;
    });

    await this.gameProvider.updateGame(updatedGame);
  }

  async applyAction(props: {
    game: Game;
    stockAction: BuySellAction;
    currentStockCount: number;
    userId: UserEntity.Id;
    count: number;
    maxCount: number;
    currentPrice: number;
    currentAveragePrice: number;
  }) {
    const {
      stockAction,
      currentStockCount,
      userId,
      count,
      maxCount,
      currentPrice,
      currentAveragePrice,
    } = props;
    const account = props.game.accounts[userId];
    const totalPrice = currentPrice * count;

    let newStockCount;
    let newAccountBalance;
    let newAveragePrice;

    switch (stockAction) {
      case 'buy':
        const isEnoughMoney = account.cash >= totalPrice;

        if (!isEnoughMoney) {
          throw new Error('Not enough money');
        }

        const isEnoughCountAvailable = maxCount < count;
        if (!isEnoughCountAvailable) {
          throw new Error('Not enough count available');
        }

        newStockCount = currentStockCount + count;
        newAccountBalance = account.cash - totalPrice;

        const wholePricesDifference = currentPrice - currentAveragePrice;
        const priceDifferenceStep = wholePricesDifference / (currentStockCount + count);
        newAveragePrice = currentAveragePrice + priceDifferenceStep * count;
        break;

      case 'sell':
        if (currentStockCount < count) {
          throw new Error('Not enough debentures');
        }

        newStockCount = currentStockCount - count;
        newAccountBalance = account.cash + totalPrice;
        newAveragePrice = currentAveragePrice;
        break;
    }

    return { newStockCount, newAccountBalance, newAveragePrice };
  }
}
