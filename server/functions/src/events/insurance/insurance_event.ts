import { GameEventEntity, GameEvent } from '../../models/domain/game/game_event';
import { InsuranceAssetEntity } from '../../models/domain/assets/insurance_asset';
import { Entity } from '../../core/domain/entity';
import { ValueRange } from '../../core/data/value_range';

export namespace InsuranceEvent {
  export const Type: GameEventEntity.Type = 'insurance-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly cost: number;
    readonly value: number;
    readonly duration: number;
    readonly insuranceType: InsuranceAssetEntity.InsuranceType;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
  }

  export type Info = {
    readonly name: string;
    readonly description: string;
    readonly cost: ValueRange;
    readonly value: ValueRange;
    readonly duration: number;
    readonly insuranceType: InsuranceAssetEntity.InsuranceType;
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'InsuranceEvent.Data');

    entity.hasNumberValue('cost');
    entity.hasNumberValue('value');
    entity.hasNumberValue('duration');
    entity.checkUnion('insuranceType', InsuranceAssetEntity.TypeValues);

    entity.checkWithRules([
      [(a) => a.cost <= 0, "Down payment can't be <= 0"],
      [(a) => a.value <= 0, "Insurance value can't be <= 0"],
      [(a) => a.duration <= 0, "Duration value can't be <= 0"],
    ]);
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'InsuranceEvent.PlayerAction'
    );

    entity.hasValue('eventId');
  };
}
