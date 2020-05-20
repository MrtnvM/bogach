import * as uuid from 'uuid';
import { ExpenseEvent } from './expense_event';

export namespace ExpenseEventGenerator {
  export const generate = (): ExpenseEvent.Event => {
    const expense = 1000;

    return {
      id: uuid.v4(),
      name: 'Неожиданно потеряли деньги',
      description: 'Что произошло',
      type: ExpenseEvent.Type,
      data: {
        expense,
      },
    };
  };
}
