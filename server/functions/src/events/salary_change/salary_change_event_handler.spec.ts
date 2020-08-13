/// <reference types="@types/jest"/>

import produce from 'immer';
import { SalaryChangeEventHandler } from './salary_change_event_handler';
import { SalaryChangeEvent } from './salary_change_event';
import { GameFixture } from '../../core/fixtures/game_fixture';
import { UserEntity } from '../../models/domain/user';

describe('Salary change event handler', () => {
  test('Successfully change salary', async () => {
    const userId: UserEntity.Id = 'user1';
    const game = GameFixture.createGame({
      participants: [userId],
      possessions: {
        [userId]: {
          incomes: [
            {
              id: 'income1',
              name: 'Salary',
              type: 'salary',
              value: 40_000,
            },
            {
              id: 'income2',
              name: 'Business',
              type: 'business',
              value: 20_000,
            },
          ],
          expenses: [],
          assets: [],
          liabilities: [],
        },
      },
    });

    const event: SalaryChangeEvent.Event = {
      id: 'event1',
      name: 'Salary change',
      description: '',
      type: SalaryChangeEvent.Type,
      data: {
        value: 1_000,
      },
    };

    const action: SalaryChangeEvent.PlayerAction = {
      eventId: 'event1',
    };

    const handler = new SalaryChangeEventHandler();
    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const salaryIncome = draft.possessions[userId].incomes.find((i) => i.type === 'salary');

      if (salaryIncome) {
        salaryIncome.value = 41_000;
      }
    });

    expect(newGame).toStrictEqual(expectedGame);
  });
});
