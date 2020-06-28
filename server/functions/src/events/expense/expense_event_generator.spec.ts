/// <reference types="@types/jest"/>

import { GameFixture } from '../../core/fixtures/game_fixture';
import { ExpenseGeneratorConfig } from './expense_generator_config';
import { ExpenseEvent } from './expense_event';
import { ExpenseEventGenerator } from './expense_event_generator';

describe('Income Event Generator', () => {
  test('Can not generate the same already happened event', () => {
    const expenseEventInfo = ExpenseGeneratorConfig.allExpenses[0];
    const expenseEvent: ExpenseEvent.Event = {
      id: 'event1',
      name: expenseEventInfo.name,
      description: expenseEventInfo.description,
      type: ExpenseEvent.Type,
      data: {
        expense: 1000,
        insuranceType: null,
      },
    };

    const game = GameFixture.createGame({
      history: {
        months: [{ events: [expenseEvent] }],
      },
    });

    for (let i = 0; i < 100; i++) {
      const event = ExpenseEventGenerator.generate(game);
      expect(event?.description).not.toEqual(expenseEvent.description);
    }
  });
});
