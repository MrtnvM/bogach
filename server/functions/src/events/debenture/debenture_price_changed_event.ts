import { GameEvent, GameEventEntity } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';
import { BuySellAction, BuySellActionValues } from '../../models/domain/actions/buy_sell_action';

export namespace DebenturePriceChangedEvent {
  export const Type: GameEventEntity.Type = 'debenture-price-changed-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly currentPrice: number;
    readonly nominal: number;
    readonly profitabilityPercent: number;
    readonly availableCount: number;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
    readonly action: BuySellAction;
    readonly count: number;
  }

  export type InfoConfig = {
    readonly nameOptions: string[];
    readonly nominal: Range;
    readonly price: Range;
    readonly profitability: Range;
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(
      event.data,
      'DebenturePriceChangedEvent.Data'
    );

    entity.hasNumberValue('currentPrice');
    entity.hasNumberValue('nominal');
    entity.hasNumberValue('profitabilityPercent');
    entity.hasNumberValue('availableCount');

    entity.checkWithRules([
      [(a) => a.availableCount <= 0, "AvailableCount can't be <= 0"],
      [(a) => a.nominal <= 0, "Nominal can't be <= 0"],
      [(a) => a.profitabilityPercent < 0, "Profitability percent can't be < 0"],
      [(a) => a.currentPrice <= 0, "Current price percent can't be <= 0"],
    ]);
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'DebenturePriceChangedEvent.PlayerAction'
    );

    entity.hasValue('eventId');
    entity.checkUnion('action', BuySellActionValues);
    entity.hasValue('count');

    entity.checkWithRules([[(a) => a.count <= 0, "Count can't be <= 0"]]);
  };
}
