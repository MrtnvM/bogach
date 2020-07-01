import { GameEvent, GameEventEntity } from '../../../models/domain/game/game_event';
import { Entity } from '../../../core/domain/entity';

export namespace BuyRealEstateEvent {
  export const Type: GameEventEntity.Type = 'buy-real-estate-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly realEstateId: string;
    readonly currentPrice: number;
    readonly fairPrice: number;
    readonly downPayment: number;
    readonly debt: number;
    readonly passiveIncomePerMonth: number;
    readonly payback: number;
    readonly sellProbability: number;
    readonly assetName: string;
  }

  export type PlayerAction = {
    readonly eventId: GameEventEntity.Id;
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'BuyRealEstateEvent.Data');

    entity.hasStringValue('realEstateId');
    entity.hasNumberValue('currentPrice');
    entity.hasNumberValue('fairPrice');
    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('debt');
    entity.hasNumberValue('passiveIncomePerMonth');
    entity.hasNumberValue('payback');
    entity.hasNumberValue('sellProbability');
    entity.hasStringValue('assetName');

    entity.checkWithRules([[(a) => a.currentPrice <= 0, "CurrentPrice can't be <= 0"]]);
    entity.checkWithRules([[(a) => a.fairPrice <= 0, "FairPrice can't be <= 0"]]);
    entity.checkWithRules([[(a) => a.downPayment <= 0, "DownPayment can't be <= 0"]]);
    entity.checkWithRules([[(a) => a.debt <= 0, "Debt can't be <= 0"]]);
    entity.checkWithRules([
      [(a) => a.passiveIncomePerMonth <= 0, "PassiveIncomePerMonth can't be <= 0"],
    ]);
  };

  export const validateAction = (action: any) => undefined;
}
