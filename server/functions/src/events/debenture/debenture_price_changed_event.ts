import { GameEvent, GameEventId } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';
import { BuySellAction } from '../../models/domain/actions/buy_sell_action';

export namespace DebenturePriceChangedEvent {
  export const Id = 'debenture-price-changed-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly currentPrice: number;
    readonly nominal: number;
    readonly profitabilityPercent: number;
    readonly maxCount: number;
  }

  export interface PlayerAction {
    readonly eventId: GameEventId;
    readonly action: BuySellAction;
    readonly count: number;
  }

  export const parse = (gameEvent: GameEvent, eventData: any): Event => {
    const { currentPrice, nominal, profitabilityPercent, maxCount } = eventData.data;

    return {
      ...gameEvent,
      data: {
        currentPrice,
        nominal,
        profitabilityPercent,
        maxCount
      }
    };
  };

  export const validate = (event: any) => {
    const entity = Entity.createEntityValidator<Data>(
      event.data,
      'DebenturePriceChangedEvent.Data'
    );

    entity.hasNumberValue('currentPrice');
    entity.hasNumberValue('nominal');
    entity.hasNumberValue('profitabilityPercent');
    entity.hasNumberValue('maxCount');

    entity.checkWithRules([
      [a => a.maxCount <= 0, "Count can't be <= 0"],
      [a => a.nominal <= 0, "Nominal can't be <= 0"],
      [a => a.profitabilityPercent < 0, "Profitability percent can't be < 0"],
      [a => a.currentPrice <= 0, "Current price percent can't be <= 0"]
    ]);
  };
}
