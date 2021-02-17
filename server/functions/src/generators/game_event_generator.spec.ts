/// <reference types="@types/jest"/>

import produce from 'immer';

import {
  stubs,
  createMockedDebentureRule,
  debentureEvent,
  createMockedStockRule,
} from './game_event_generator.spec.utils';
import { GameEventGenerator } from './game_event_generator';
import { DebentureGenerateRule } from './rules/debenture_generate_rule';
import { DebentureEvent } from '../events/debenture/debenture_event';
import { StockEvent } from '../events/stock/stock_event';
import { RuleConfig } from './generator_rule';

describe('Game Event Generator', () => {
  const { game } = stubs;

  const defaultDebentureRuleConfig: RuleConfig = {
    probabilityLevel: 10,
    maxCountOfEventInMonth: 1,
    minDistanceBetweenEvents: 0,
    maxHistoryLength: -1,
  };

  test('Cannot create generator with empty rules set', () => {
    expect(() => new GameEventGenerator({ rules: [] })).toThrowError();
  });

  test('Events count for generation', () => {
    const generator1 = new GameEventGenerator({
      eventCountForGeneration: 8,
      rules: [new DebentureGenerateRule(defaultDebentureRuleConfig)],
    });

    expect(generator1.getEventCountForGeneration(game)).toEqual(8);

    const generator2 = new GameEventGenerator({
      rules: [new DebentureGenerateRule(defaultDebentureRuleConfig)],
    });

    expect(generator2.getEventCountForGeneration(game)).toBeGreaterThanOrEqual(5);
  });

  test('Successfully generates events needed count of events', () => {
    const countOfEventsForGenerationConfigValue = 7;

    const debentureRule = createMockedDebentureRule({
      minDistance: 0,
      maxEventsInMonth: 1,
      probabilityLevel: [10],
    });
    const stocksRule = createMockedStockRule({
      minDistance: 0,
      maxEventsInMonth: countOfEventsForGenerationConfigValue - 1,
      probabilityLevel: [10],
    });

    const generator = new GameEventGenerator({
      rules: [debentureRule, stocksRule],
      eventCountForGeneration: countOfEventsForGenerationConfigValue,
    });

    const countOfEventsForGeneration = generator.getEventCountForGeneration(game);
    const gameEvents = generator.generateEvents(game);

    expect(gameEvents.length).toEqual(countOfEventsForGeneration);

    const debentureEvents = gameEvents.filter((e) => e.type === DebentureEvent.Type);
    expect(debentureEvents.length).toEqual(1);

    const stockEvents = gameEvents.filter((e) => e.type === StockEvent.Type);
    expect(stockEvents.length).toEqual(6);
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

  test('Check min duration more than 1 month', () => {
    const debentureRule = createMockedDebentureRule({
      minDistance: 2,
      probabilityLevel: [10],
    });

    const generator = new GameEventGenerator({
      rules: [debentureRule],
    });

    const event1 = debentureEvent();
    const game1 = produce(game, (draft) => {
      draft.history = {
        months: [{ events: [event1] }, { events: [] }],
      };
    });

    const gameEvents1 = generator.generateEvents(game1);
    expect(gameEvents1.length).toEqual(0);

    const event2 = debentureEvent();
    const game2 = produce(game, (draft) => {
      draft.history = {
        months: [{ events: [event2] }, { events: [] }, { events: [] }],
      };
    });

    const gameEvents2 = generator.generateEvents(game2);
    expect(gameEvents2.length).toEqual(1);
  });
});
