import { InsuranceEvent } from './insurance_event';
import uuid = require('uuid');
import { randomValueFromRange } from '../../core/data/value_range';
import { Game, GameEntity } from '../../models/domain/game/game';

export namespace InsuranceEventGenerator {
  export const generate = (
    game: Game,
    insuranceInfo: InsuranceEvent.Info,
    maxHistoryLength: number
  ): InsuranceEvent.Event | undefined => {
    const pastInsuranceEvents = GameEntity.getPastEventsOfType<InsuranceEvent.Event>({
      game,
      type: InsuranceEvent.Type,
      maxHistoryLength,
    });

    const theSameInsuranceTypeEventIndex = pastInsuranceEvents.findIndex(
      (e) => e.data.insuranceType === insuranceInfo.insuranceType
    );

    if (theSameInsuranceTypeEventIndex >= 0) {
      return undefined;
    }

    return generateEvent(insuranceInfo);
  };

  export const generateEvent = (insuranceInfo: InsuranceEvent.Info): InsuranceEvent.Event => {
    return {
      id: uuid.v4(),
      name: insuranceInfo.name,
      description: insuranceInfo.description,
      type: InsuranceEvent.Type,
      data: {
        insuranceType: insuranceInfo.insuranceType,
        duration: insuranceInfo.duration,
        value: randomValueFromRange(insuranceInfo.value),
        cost: randomValueFromRange(insuranceInfo.cost),
      },
    };
  };

  export const archiveEvent = (event: InsuranceEvent.Event) => {
    return {
      type: event.type,
      data: {
        insuranceType: event.data.insuranceType,
      },
    };
  };
}
