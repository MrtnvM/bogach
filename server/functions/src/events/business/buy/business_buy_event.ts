import { GameEventEntity, GameEvent } from '../../../models/domain/game/game_event';
import { BuySellAction, BuySellActionValues } from '../../../models/domain/actions/buy_sell_action';
import { Entity } from '../../../core/domain/entity';
import { ValueRange } from '../../../core/data/value_range';

export namespace BusinessBuyEvent {
  export const Type: GameEventEntity.Type = 'business-buy-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly businessId: string;
    readonly currentPrice: number;
    readonly fairPrice: number;
    readonly downPayment: number;
    readonly debt: number;
    readonly passiveIncomePerMonth: number;
    readonly payback: number;
    readonly sellProbability: number;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
    readonly action: BuySellAction;
  }

  export type Info = {
    readonly name: string;
    readonly description: string;
    readonly businessId: string;
    readonly currentPrice: ValueRange;
    readonly fairPrice: ValueRange;
    readonly downPayment: ValueRange;
    readonly passiveIncomePerMonth: ValueRange;
    readonly sellProbability: ValueRange;
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'BusinessOfferEvent.Data');

    entity.hasValue('businessId');
    entity.hasNumberValue('currentPrice');
    entity.hasNumberValue('fairPrice');
    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('debt');
    entity.hasNumberValue('passiveIncomePerMonth');
    entity.hasNumberValue('payback');
    entity.hasNumberValue('sellProbability');

    entity.checkWithRules([
      [(a) => a.currentPrice <= 0, "CurrentPrice can't be <= 0"],
      [(a) => a.fairPrice <= 0, "FairPrice can't be <= 0"],
      [(a) => a.downPayment <= 0, "DownPayment percent can't be <= 0"],
      [(a) => a.debt <= 0, "Debt percent can't be <= 0"],
      [(a) => a.sellProbability <= 0, "SellProbability price percent can't be <= 0"],
    ]);
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'BusinessOfferEvent.PlayerAction'
    );

    entity.hasValue('eventId');
    entity.checkUnion('action', BuySellActionValues);
  };
}
