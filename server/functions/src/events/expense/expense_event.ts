import { GameEvent, GameEventEntity } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';

export namespace ExpenseEvent {
  export const Type: GameEventEntity.Type = 'expense-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly expense: number;
  }

  export interface PlayerAction {}

  export const parse = (gameEvent: GameEvent, eventData: any): Event => {
    const { expense } = eventData.data;

    return {
      ...gameEvent,
      data: {
        expense,
      },
    };
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'ExpenseEvent.Data');

    entity.hasNumberValue('expense');

    entity.checkWithRules([[(a) => a.expense <= 0, "Expense can't be <= 0"]]);
  };

  export const validateAction = (action: any) => {};
}
