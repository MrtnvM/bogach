/// <reference types="@types/jest"/>

import produce from 'immer';

import { stubs, createMockedDebentureRule, debentureEvent } from './event_generator.spec.utils';
import { GameEventGenerator } from './event_generator';
import { DebentureGenerateRule } from './rules/debenture_generate_rule';
import { StockGenerateRule } from './rules/stock_generate_rule';
import { ExpenseGenerateRule } from './rules/expense_generate_rule';
import { MonthlyExpenseGenerateRule } from './rules/monthly_expense_generate_rule';

describe('Game Event Generator', () => {
  const { game } = stubs;

  test('Cannot create generator with empty rules set', () => {
    expect(() => new GameEventGenerator({ rules: [] })).toThrowError();
  });

  test('Events count for generation', () => {
    const generator1 = new GameEventGenerator({
      eventCountForGeneration: 8,
      rules: [new DebentureGenerateRule()],
    });

    expect(generator1.getEventCountForGeneration(game)).toEqual(8);

    const generator2 = new GameEventGenerator({
      rules: [new DebentureGenerateRule()],
    });

    expect(generator2.getEventCountForGeneration(game)).toBeGreaterThanOrEqual(5);
  });

  test('Successfully generates events needed count of events', () => {
    const generator = new GameEventGenerator({
      rules: [
        new DebentureGenerateRule(),
        new StockGenerateRule(),
        new MonthlyExpenseGenerateRule(),
        new ExpenseGenerateRule(),
      ],
    });

    const countOfeventsForGeneration = generator.getEventCountForGeneration(game);
    const gameEvents = generator.generateEvents(game);

    expect(gameEvents.length).toEqual(countOfeventsForGeneration);
  });

  test('Checks level bounds', () => {
    const debentureRule = createMockedDebentureRule({
      minDistance: 0,
      probabilityLevel: [-1, 11, 10],
    });

    const generator = new GameEventGenerator({
      rules: [debentureRule],
    });

    const neededEventsCount = generator.getEventCountForGeneration(game);

    // Should throw 2 times because of incorrect value for Probability Level
    expect(() => generator.generateEvents(game)).toThrowError();
    expect(() => generator.generateEvents(game)).toThrowError();

    expect(generator.generateEvents(game).length).toEqual(neededEventsCount);
  });

  test('Has boundaries for generation of events trying times', () => {
    const debentureRule = createMockedDebentureRule({
      minDistance: 1,
      probabilityLevel: [10],
    });

    const generator = new GameEventGenerator({
      rules: [debentureRule],
    });

    const neededEventsCount = generator.getEventCountForGeneration(game);
    const gameEvents = generator.generateEvents(game);

    expect(gameEvents.length).not.toEqual(neededEventsCount);
    expect(gameEvents.length).toEqual(1);
  });

  test.only('Check min duration more than 1 month', () => {
    const debentureRule = createMockedDebentureRule({
      minDistance: 2,
      probabilityLevel: [10],
    });

    const generator = new GameEventGenerator({
      rules: [debentureRule],
    });

    const event1 = debentureEvent();
    const game1 = produce(game, (draft) => {
      draft.history = { monthEvents: [[event1], []] };
    });

    const gameEvents1 = generator.generateEvents(game1);
    expect(gameEvents1.length).toEqual(0);

    const event2 = debentureEvent();
    const game2 = produce(game, (draft) => {
      draft.history = { monthEvents: [[event2], [], []] };
    });

    const gameEvents2 = generator.generateEvents(game2);
    expect(gameEvents2.length).toEqual(1);
  });
});
