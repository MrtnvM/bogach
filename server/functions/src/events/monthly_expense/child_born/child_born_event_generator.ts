import uuid = require('uuid');
import { MonthlyExpenseEvent } from '../monthly_expense_event';
import { GameEntity, Game } from '../../../models/domain/game/game';

export namespace ChildBornGenerator {
  export const generate = (game: Game): MonthlyExpenseEvent.Event | undefined => {
    const eventId = uuid.v4();

    const pastMonthlyExpenseEvents = GameEntity.getPastEventsOfType<MonthlyExpenseEvent.Event>({
      game,
      type: MonthlyExpenseEvent.Type,
      maxHistoryLength: 24,
    });

    const name = 'Поздравляем с рождением ребёнка!';
    const description = 'В вашей семье пополнение';
    const monthlyPayment = 5000;

    const childEventAlreadyHappened = pastMonthlyExpenseEvents.some((e) => {
      return e.name === name;
    });

    if (childEventAlreadyHappened) {
      return undefined;
    }

    return {
      id: eventId,
      name,
      description,
      type: MonthlyExpenseEvent.Type,
      data: {
        monthlyPayment,
        expenseName: 'Ребёнок',
      },
    };
  };
}
