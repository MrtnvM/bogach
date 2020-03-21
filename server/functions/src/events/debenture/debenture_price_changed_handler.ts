import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { DebenturePriceChangedEvent } from './debenture_price_changed_event';
import { PlayerAction } from '../../models/domain/player_action';
import { AssetProvider } from '../../providers/asset_provider';
import { AccountProvider } from '../../providers/account_provider';
import { AssetEntity } from '../../models/domain/asset';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { Strings } from '../../resources/strings';
import { UserId } from '../../models/domain/user';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';

type Event = DebenturePriceChangedEvent.Event;
type Action = DebenturePriceChangedEvent.PlayerAction;

export class DebenturePriceChangedHandler extends PlayerActionHandler<Event, Action> {
  constructor(private assetProvider: AssetProvider, private accountProvider: AccountProvider) {
    super();
  }

  get gameEventType(): string {
    return DebenturePriceChangedEvent.Id;
  }

  async validate(event: Event): Promise<boolean> {
    try {
      DebenturePriceChangedEvent.validate(event);
    } catch (error) {
      console.error(error);
    }

    return true;
  }

  async handle(action: PlayerAction<Event, Action>): Promise<void> {
    const debentureAssetType: AssetEntity.Type = 'debeture';
    const userId = action.userId;
    const event = action.gameEvent;
    const { currentPrice, nominal, profitabilityPercent } = event.data;
    const { count, action: debentureAction } = action.payload;

    const assets = await this.assetProvider.getAllAssets(userId);
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
      count,
      debentureAction,
      currentDebentureCount,
      userId,
      debenturePrice: currentPrice
    });

    if (theSameDebenture) {
      const newDebenture = { ...theSameDebenture, count: newDebentureCount };
      this.assetProvider.updateAsset(userId, newDebenture);
    } else {
      const newDebenture: DebentureAsset = {
        currentPrice,
        nominal,
        profitabilityPercent,
        count: newDebentureCount,
        name: Strings.debetures(),
        type: 'debeture'
      };

      this.assetProvider.addAsset(userId, newDebenture);
    }
  }

  async getNewDebentureCount(props: {
    debentureAction: BuySellAction;
    currentDebentureCount: number;
    userId: UserId;
    count: number;
    debenturePrice: number;
  }) {
    const { debentureAction, currentDebentureCount, userId, count, debenturePrice } = props;
    const account = await this.accountProvider.getAccount(userId);

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
