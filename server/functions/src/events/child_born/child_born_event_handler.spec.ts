import { GameEntity } from '../../models/domain/game/game';
import { ChildBornEventHandler } from './child_born_event_handler';
import { stubs, utils } from './child_born_event_handler.spec.utils';
import { ChildBornEvent } from './child_born_event';
import uuid = require('uuid');
import produce from 'immer';
import { Expense } from '../../models/domain/expense';

describe('Expense event handler', () => {
  const { userId, game } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully get one child', async () => {
    const handler = new ChildBornEventHandler();

    const event = utils.childBornEvent({
      monthlyPayment: 250,
    });

    const action: ChildBornEvent.PlayerAction = {
      eventId: uuid.v4(),
    };

    const newGame = await handler.handle(game, event, action, userId);

    const newExpense: Expense = {
      name: 'Ребёнок 1',
      type: 'child',
      value: 250,
    };
    const expectedGame = produce(game, (draft) => {
      draft.possessions[userId].expenses.push(newExpense);
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully get two child', async () => {
    const handler = new ChildBornEventHandler();

    const event = utils.childBornEvent({
      monthlyPayment: 250,
    });

    const action: ChildBornEvent.PlayerAction = {
      eventId: uuid.v4(),
    };

    const firstChild: Expense = {
      name: 'Ребёнок 1',
      type: 'child',
      value: 250,
    };

    const gameWithChild = produce(game, (draft) => {
      draft.possessions[userId].expenses.push(firstChild);
    });

    const newGame = await handler.handle(gameWithChild, event, action, userId);

    const secondChild: Expense = {
      name: 'Ребёнок 2',
      type: 'child',
      value: 250,
    };
    const expectedGame = produce(gameWithChild, (draft) => {
      draft.possessions[userId].expenses.push(secondChild);
    });

    expect(newGame).toStrictEqual(expectedGame);
  });
});
