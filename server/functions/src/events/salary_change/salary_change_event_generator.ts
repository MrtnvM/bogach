import * as uuid from 'uuid';

import { SalaryChangeEvent } from './salary_change_event';
import { randomValueFromRange } from '../../core/data/value_range';

export namespace SalaryChangeEventGenerator {
  export const generateEvent = (eventInfo: SalaryChangeEvent.Info): SalaryChangeEvent.Event => {
    const { name, description, value } = eventInfo;

    return {
      id: uuid.v4(),
      name,
      description,
      type: SalaryChangeEvent.Type,
      data: {
        value: randomValueFromRange(value),
      },
    };
  };
}
