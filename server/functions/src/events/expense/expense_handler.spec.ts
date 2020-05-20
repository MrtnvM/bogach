/// <reference types="@types/jest"/>

import { GameEntity } from '../../models/domain/game/game';
import { stubs, utils } from './expense_handler.spec.utils';
import produce from 'immer';
import { ExpenseHandler } from './expense_handler';

describe('Expense event handler', () => {
  const { userId, game, initialCash } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully get expense', async () => {
    const handler = new ExpenseHandler();

    const event = utils.expenseEvent({
      expense: 1100,
    });

    const action = utils.expensePlayerAction({
      accepted: true,
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      draft.accounts[userId].cash = initialCash - 1100;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });
});
