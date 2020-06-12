import uuid = require('uuid');
import { MonthlyExpenseEvent } from '../monthly_expense_event';

export namespace ChildBornGenerator {
  export const generate = (): MonthlyExpenseEvent.Event => {
    const eventId = uuid.v4();

    const name = 'Поздравляем с рождением ребёнка!';
    const description = 'В вашей семье пополнение';
    const monthlyPayment = 250;

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
