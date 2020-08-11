import { GameEventEntity, GameEvent } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';
import { ValueRange } from '../../core/data/value_range';

export namespace SalaryChangeEvent {
  export const Type: GameEventEntity.Type = 'salary-change-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly value: number;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
  }

  export type Info = {
    readonly name: string;
    readonly description: string;
    readonly value: ValueRange;
  };

  export const validate = (event: any) => {
    if (event.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'MonthlyExpenseEvent.Data');

    entity.hasNumberValue('value');

    entity.checkWithRules([[(a) => a.value === 0, "Salary change can't be == 0"]]);
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'SalaryChangeEvent.PlayerAction'
    );

    entity.hasValue('eventId');
  };
}
