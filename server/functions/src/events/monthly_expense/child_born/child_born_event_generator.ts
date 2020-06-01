import uuid = require('uuid');
import { MonthlyExpenseEvent } from '../monthly_expense_event';
import { Game } from '../../../models/domain/game/game';

export namespace ChildBornGenerator {
  export const generate = (game: Game): MonthlyExpenseEvent.Event => {
    const eventId = uuid.v4();

    const name = 'Поздравляем с рождением ребёенка!';
    const description = 'В вашей семье пополнение';
    const monthlyPayment = 250;

    return {
      id: eventId,
      name,
      description,
      type: MonthlyExpenseEvent.Type,
      data: {
        monthlyPayment,
        expenseType: 'child',
        expenseName: 'Ребёнок'
      },
    };
  };
}
