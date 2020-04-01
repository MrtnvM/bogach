import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { DebenturePriceChangedEvent } from './debenture_price_changed_event';
import { AssetEntity } from '../../models/domain/asset';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { Strings } from '../../resources/strings';
import { UserEntity } from '../../models/domain/user';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';
import { GameContext } from '../../models/domain/game/game_context';
import { GameProvider } from '../../providers/game_provider';
import { Game } from '../../models/domain/game/game';

type Event = DebenturePriceChangedEvent.Event;
type Action = DebenturePriceChangedEvent.PlayerAction;

export class DebenturePriceChangedHandler extends PlayerActionHandler<Event, Action> {
  constructor(private gameProvider: GameProvider) {
    super();
  }

  get gameEventType(): string {
    return DebenturePriceChangedEvent.Id;
  }

  async validate(event: Event, action: Action): Promise<boolean> {
    try {
      DebenturePriceChangedEvent.validate(event);
    } catch (error) {
      console.error(error);
    }

    return true;
  }

  async handle(event: Event, action: Action, context: GameContext): Promise<void> {
    const { gameId, userId } = context;
    const game = await this.gameProvider.getGame(gameId);

    const debentureAssetType: AssetEntity.Type = 'debenture';

    const { currentPrice, nominal, profitabilityPercent } = event.data;
    const { count, action: debentureAction } = action;

    const assets = game.possessions[userId].assets;
    const debetureAssets = assets.filter(a => a.type === debentureAssetType) as DebentureAsset[];

    const theSameDebenture = debetureAssets.find(d => {
      return (
        d.currentPrice === currentPrice &&
        d.nominal === nominal &&
        d.profitabilityPercent === profitabilityPercent
      );
    });

    const currentDebentureCount = theSameDebenture?.count || 0;
    const newDebentureCount = await this.getNewDebentureCount({
      game,
      count,
      debentureAction,
      currentDebentureCount,
      userId,
      debenturePrice: currentPrice
    });

    let newAssets;

    if (theSameDebenture) {
      const newDebenture = { ...theSameDebenture, count: newDebentureCount };
      newAssets = assets.slice().filter(d => d.id !== newDebenture.id);
      newAssets.push(newDebenture);
    } else {
      const newDebenture: DebentureAsset = {
        currentPrice,
        nominal,
        profitabilityPercent,
        count: newDebentureCount,
        name: Strings.debetures(),
        type: 'debenture'
      };

      newAssets = assets.slice();
      newAssets.push(newDebenture);
    }

    const updatedGame: Game = {
      ...game,
      possessions: {
        ...game.possessions,
        [userId]: { ...game.possessions[userId], assets: newAssets }
      }
    };

    await this.gameProvider.updateGame(updatedGame);
  }

  async getNewDebentureCount(props: {
    game: Game;
    debentureAction: BuySellAction;
    currentDebentureCount: number;
    userId: UserEntity.Id;
    count: number;
    debenturePrice: number;
  }) {
    const { debentureAction, currentDebentureCount, userId, count, debenturePrice } = props;
    const account = props.game.accounts[userId];

    let newDebentureCount = currentDebentureCount;

    switch (debentureAction) {
      case 'buy':
        const totalPrice = debenturePrice * count;
        const isEnoughMoney = account.balance >= totalPrice;

        if (!isEnoughMoney) {
          throw 'ERROR: Not enough money';
        }

        newDebentureCount += count;
        break;

      case 'sell':
        if (currentDebentureCount < count) {
          throw 'ERROR: Not enough debentures';
        }

        newDebentureCount -= count;
        break;
    }

    return newDebentureCount;
  }
}
