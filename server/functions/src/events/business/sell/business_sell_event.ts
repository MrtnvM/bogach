import { GameEvent, GameEventEntity } from '../../../models/domain/game/game_event';
import { Entity } from '../../../core/domain/entity';
import { BuySellAction, BuySellActionValues } from '../../../models/domain/actions/buy_sell_action';

export namespace BusinessSellEvent {
  export const Type: GameEventEntity.Type = 'business-sell-event';

  export type Event = GameEvent<Data>;

  export interface Data {
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

  export const parse = (gameEvent: GameEvent, eventData: any): Event => {
    const {
      currentPrice,
      fairPrice,
      downPayment,
      debt,
      passiveIncomePerMonth,
      payback,
      sellProbability,
    } = eventData.data;

    return {
      ...gameEvent,
      data: {
        currentPrice,
        fairPrice,
        downPayment,
        debt,
        passiveIncomePerMonth,
        payback,
        sellProbability,
      },
    };
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'BusinessOfferEvent.Data');

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
