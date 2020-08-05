import { GameEventEntity, GameEvent } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';
import { ValueRange } from '../../core/data/value_range';

export namespace MonthlyExpenseEvent {
  export const Type: GameEventEntity.Type = 'monthly-expense-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly monthlyPayment: number;
    readonly expenseName: string;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
  }

  export type Info = {
    readonly name: string;
    readonly description: string;
    readonly value: ValueRange;
    readonly expenseName: string;
  };

  export const validate = (event: any) => {
    if (event.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'MonthlyExpenseEvent.Data');

    entity.hasNumberValue('monthlyPayment');
    entity.hasValue('expenseName');

    entity.checkWithRules([[(a) => a.monthlyPayment < 0, "Monthly payment can't be <= 0"]]);
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'MonthlyExpenseEvent.PlayerAction'
    );

    entity.hasValue('eventId');
  };
}
