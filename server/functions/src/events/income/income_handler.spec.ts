/// <reference types="@types/jest"/>

import { GameEntity } from '../../models/domain/game/game';
import { stubs, utils } from './income_handler.spec.utils';
import produce from 'immer';
import { IncomeHandler } from './income_handler';

describe('Income event handler', () => {
  const { userId, game, initialCash } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully get income', async () => {
    const handler = new IncomeHandler();

    const event = utils.incomeEvent({
      income: 1100,
    });

    const action = utils.incomePlayerAction({
      accepted: true,
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      draft.accounts[userId].cash = initialCash + 1100;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });
});
