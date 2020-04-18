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

    const { currentPrice, fairPrice, portfolioCount, maxCount } = event.data;
    const { count, action: stockAction } = action;

    const assets = game.possessions[userId].assets;
    const stockAssets = AssetEntity.getStocks(assets);

    const theSameStock = stockAssets.find((d) => {
      return (
        d.name === name &&
        d.fairPrice === fairPrice //&&
        //d.profitabilityPercent === profitabilityPercent
        // TODO need add other fields? 
        // why not by id?
      );
    });

    const currentStockCount = theSameStock?.count || 0;

    //TODO function name applyAction?
    const { newStockCount, newAccountBalance } = await this.getNewStockCount({
      game,
      stockAction,
      currentStockCount,
      userId,
      count,
      maxCount,
      currentPrice,
    });

    // TODO slice?
    let newAssets = assets.slice();

    if (theSameStock) {
      const newStock = { ...theSameStock, count: newStockCount };
      const index = assets.findIndex((d) => d.id === newStock.id);

      if (index >= 0) {
        newAssets[index] = newStock;
      }

      if (newStock.count === 0) {
        newAssets = assets.filter((d) => d.id !== newStock.id);
      }
    } else {
      const newStock: StockAsset = {
        currentPrice,
        fairPrice,
        count: newStockCount,
        name: Strings.debetures(),
        // TODO check stock or stocks
        type: 'stocks',
      };

      newAssets.push(newStock);
    }

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].cash = newAccountBalance;
      draft.possessions[userId].assets = newAssets;
    });

    await this.gameProvider.updateGame(updatedGame);
  }

  async getNewStockCount(props: {
    game: Game;
    stockAction: BuySellAction;
    currentStockCount: number;
    userId: UserEntity.Id;
    count: number;
    maxCount: number;
    currentPrice: number;
  }) {
    const { stockAction, currentStockCount, userId, count, maxCount, currentPrice } = props;
    const account = props.game.accounts[userId];
    const totalPrice = currentPrice * count;

    let newStockCount;
    let newAccountBalance;

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
        break;

      case 'sell':
        if (currentStockCount < count) {
          throw new Error('Not enough debentures');
        }

        newStockCount = currentStockCount - count;
        newAccountBalance = account.cash + totalPrice;
        break;
    }

    return { newStockCount: newStockCount, newAccountBalance };
  }
}
