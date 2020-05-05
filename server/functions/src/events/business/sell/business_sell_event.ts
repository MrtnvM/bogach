import { GameEvent, GameEventEntity } from '../../../models/domain/game/game_event';
import { Entity } from '../../../core/domain/entity';
import { BuySellAction, BuySellActionValues } from '../../../models/domain/actions/buy_sell_action';

export namespace BusinessSellEvent {
  export const Type: GameEventEntity.Type = 'business-sell-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly businessId: string;
    readonly currentPrice: number;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
    readonly action: BuySellAction;
  }

  export const parse = (gameEvent: GameEvent, eventData: any): Event => {
    const { businessId, currentPrice } = eventData.data;

    return {
      ...gameEvent,
      data: {
        businessId,
        currentPrice,
      },
    };
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'BusinessOfferEvent.Data');

    entity.hasValue('businessId');
    entity.hasNumberValue('currentPrice');

    entity.checkWithRules([[(a) => a.currentPrice <= 0, "CurrentPrice can't be <= 0"]]);
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'BusinessSellEvent.PlayerAction'
    );

    entity.hasValue('eventId');
    entity.checkUnion('action', BuySellActionValues);
  };
}
