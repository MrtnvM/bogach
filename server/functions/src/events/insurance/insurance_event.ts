import { GameEventEntity, GameEvent } from '../../models/domain/game/game_event';
import { InsuranceAssetEntity } from '../../models/domain/assets/insurance_asset';
import { Entity } from '../../core/domain/entity';

export namespace InsuranceEvent {
  export const Type: GameEventEntity.Type = 'insurance-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly cost: number;
    readonly value: number;
    readonly movesLeft: number;
    readonly insuranceType: InsuranceAssetEntity.InsuranceType;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
  }

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'InsuranceEvent.Data');

    entity.hasNumberValue('cost');
    entity.hasNumberValue('value');
    entity.hasNumberValue('movesLeft');
    entity.checkUnion('insuranceType', InsuranceAssetEntity.TypeValues);

    entity.checkWithRules([
      [(a) => a.cost <= 0, "Down payment can't be <= 0"],
      [(a) => a.value <= 0, "Insurance value can't be <= 0"],
      [(a) => a.movesLeft <= 0, "MovesLeft value can't be <= 0"],
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
