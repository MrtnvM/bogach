import { GameEvent, GameEventEntity } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';
import { InsuranceAssetEntity } from '../../models/domain/assets/insurance_asset';
import { ValueRange } from '../../core/data/value_range';

export namespace ExpenseEvent {
  export const Type: GameEventEntity.Type = 'expense-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly expense: number;
    readonly insuranceType: InsuranceAssetEntity.InsuranceType | null;
  }

  export type PlayerAction = {};

  export type Info = {
    readonly name: string;
    readonly description: string;
    readonly insuranceType: InsuranceAssetEntity.InsuranceType | null;
    readonly range: ValueRange;
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'ExpenseEvent.Data');

    entity.hasNumberValue('expense');
    entity.checkNullableUnion('insuranceType', InsuranceAssetEntity.TypeValues);

    // TODO: Restore when will be implemented decreasing liability for business
    // entity.checkWithRules([[(a) => a.expense <= 0, "Expense can't be <= 0"]]);
  };

  export const validateAction = (action: any) => undefined;
}
