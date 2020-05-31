import uuid = require('uuid');
import { ChildBornEvent } from './child_born_event';

export namespace ChildBornGenerator {
  export const generate = (): ChildBornEvent.Event => {
    const eventId = uuid.v4();
    const name = 'Поздравляем с рождением ребёенка!';
    const description = 'В вашей семье пополнение';
    const monthlyPayment = 250;

    return {
      id: eventId,
      name,
      description,
      type: ChildBornEvent.Type,
      data: {
        monthlyPayment,
      },
    };
  };
}
