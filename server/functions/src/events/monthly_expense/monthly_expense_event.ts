import { GameEventEntity, GameEvent } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';
import { ExpenseEntity, ExpenseTypeValues } from '../../models/domain/expense';

export namespace MonthlyExpenseEvent {
  export const Type: GameEventEntity.Type = 'monthly-expense-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly monthlyPayment: number;
    readonly expenseType: ExpenseEntity.Type;
    readonly expenseName: string;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
  }

  export const parse = (gameEvent: GameEvent, eventData: any): Event => {
    const { monthlyPayment, expenseType, expenseName } = eventData.data;

    return {
      ...gameEvent,
      data: {
        monthlyPayment,
        expenseType,
        expenseName,
      },
    };
  };

  export const validate = (event: any) => {
    if (event.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'MonthlyExpenseEvent.Data');

    entity.hasNumberValue('monthlyPayment');
    entity.checkUnion('expenseType', ExpenseTypeValues);
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
