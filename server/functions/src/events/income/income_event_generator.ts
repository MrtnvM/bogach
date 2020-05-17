import * as uuid from 'uuid';
import { IncomeEvent } from './income_event';

export namespace IncomeEventGenerator {
  export const generate = (): IncomeEvent.Event => {
    const income = 1000;

    return {
      id: uuid.v4(),
      name: 'Название события',
      description: 'Что произошло',
      type: IncomeEvent.Type,
      data: {
        income,
      },
    };
  };
}
