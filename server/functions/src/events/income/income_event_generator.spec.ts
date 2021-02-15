/// <reference types="@types/jest"/>

import { GameFixture } from '../../core/fixtures/game_fixture';
import { IncomeGeneratorConfig } from './income_generator_config';
import { IncomeEvent } from './income_event';
import { IncomeEventGenerator } from './income_event_generator';

describe('Income Event Generator', () => {
  test('Can not generate the same already happened event', () => {
    const incomeEventInfo = IncomeGeneratorConfig.allIncomes[0];
    const incomeEvent: IncomeEvent.Event = {
      id: 'event1',
      name: incomeEventInfo.name,
      description: incomeEventInfo.description,
      type: IncomeEvent.Type,
      data: {
        income: 1000,
      },
    };

    const game = GameFixture.createGame({
      history: {
        months: [{ events: [incomeEvent] }],
      },
    });

    for (let i = 0; i < 100; i++) {
      const incomeEvents = IncomeGeneratorConfig.allIncomes;
      const event = IncomeEventGenerator.generate(game, incomeEvents, 12);
      expect(event?.description).not.toEqual(incomeEvent.description);
    }
  });
});
