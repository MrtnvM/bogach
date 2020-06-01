import { GameEntity } from '../../../models/domain/game/game';
import { MonthlyExpenseEventHandler } from '../monthly_expense_event_handler';
import { stubs, utils } from './child_born_event_handler.spec.utils';
import { MonthlyExpenseEvent } from '../monthly_expense_event';
import uuid = require('uuid');
import produce from 'immer';
import { Expense } from '../../../models/domain/expense';

describe('Expense event handler', () => {
  const { userId, game } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully get one child', async () => {
    const handler = new MonthlyExpenseEventHandler();

    const event = utils.monthlyExpenseEvent({
      monthlyPayment: 250,
      expenseType: 'child',
      expenseName: 'Ребёнок',
    });

    const action: MonthlyExpenseEvent.PlayerAction = {
      eventId: uuid.v4(),
    };

    const newGame = await handler.handle(game, event, action, userId);

    const newExpense: Expense = {
      name: 'Ребёнок',
      type: 'child',
      value: 250,
    };
    const expectedGame = produce(game, (draft) => {
      draft.possessions[userId].expenses.push(newExpense);
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully get two child', async () => {
    const handler = new MonthlyExpenseEventHandler();

    const event = utils.monthlyExpenseEvent({
      monthlyPayment: 250,
      expenseType: 'child',
      expenseName: 'Игнат',
    });

    const action: MonthlyExpenseEvent.PlayerAction = {
      eventId: uuid.v4(),
    };

    const firstChild: Expense = {
      name: 'Валера',
      type: 'child',
      value: 250,
    };

    const gameWithChild = produce(game, (draft) => {
      draft.possessions[userId].expenses.push(firstChild);
    });

    const newGame = await handler.handle(gameWithChild, event, action, userId);

    const secondChild: Expense = {
      name: 'Игнат',
      type: 'child',
      value: 250,
    };
    const expectedGame = produce(gameWithChild, (draft) => {
      draft.possessions[userId].expenses.push(secondChild);
    });

    expect(newGame).toStrictEqual(expectedGame);
  });
});
