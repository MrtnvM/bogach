import { produce } from 'immer';
import * as random from 'random';

import { Rule } from './generator_rule';
import { Game } from '../models/domain/game/game';
import { GameEvent } from '../models/domain/game/game_event';

type Range = { min: number; max: number };

export type GameEventGeneratorConfig = {
  readonly eventCountForGeneration?: number;
  readonly rules: Rule<GameEvent>[];
};

export class GameEventGenerator {
  constructor(private config: GameEventGeneratorConfig) {
    if (!config.rules || config.rules.length === 0) {
      throw new Error('ERROR: Cannot create generator with empty rules set');
    }
  }

  getEventCountForGeneration(game: Game) {
    return this.config.eventCountForGeneration || 7;
  }

  generateEvents(game: Game): GameEvent[] {
    const { rules } = this.config;

    const ruleRanges: Range[] = [];
    let maxProbabilityLevel = 0;

    for (const rule of rules) {
      const level = rule.getProbabilityLevel();

      if (level < 0 || level > 10) {
        throw new Error(
          'ERROR: Incorrect value for probability level. It should be in interval 0...10 ' +
            'and it should be integer number'
        );
      }

      const probabilityLevel = parseInt(level.toString(), 10);
      const range: Range = {
        min: maxProbabilityLevel,
        max: maxProbabilityLevel + probabilityLevel,
      };

      ruleRanges.push(range);
      maxProbabilityLevel += probabilityLevel;
    }

    let gameEvents: GameEvent[] = [];
    const neededGameEventsCount = this.getEventCountForGeneration(game);

    // For preventing infinite loop used counter of iterations of trying generate single game event
    let skippedEventCount = 0;
    const maxEmptyIterationCount = 10_000;

    // For event generation used game updated with generated game events.
    // It's required for concrete game event generator have an ability
    // to modify event content according to already existing events in the current month
    let updatedGame = produce(game, (draft) => {
      draft.currentEvents = [];
    });

    while (gameEvents.length < neededGameEventsCount) {
      if (skippedEventCount >= maxEmptyIterationCount) {
        break;
      }

      const randomRuleLevel = random.int(0, maxProbabilityLevel);

      const ruleIndex = ruleRanges.findIndex((range) => {
        return range.min <= randomRuleLevel && randomRuleLevel <= range.max;
      });

      if (ruleIndex < 0 || ruleIndex >= rules.length) {
        skippedEventCount++;
        continue;
      }

      const rule = rules[ruleIndex];
      const shouldSkipEvent = this.checkIfShouldSkipEvent(rule, updatedGame);

      if (shouldSkipEvent) {
        skippedEventCount++;
        continue;
      }

      let gameEvent: GameEvent<any> | undefined;

      try {
        gameEvent = rule.generate(updatedGame);
      } catch (e) {
        const errorMessage =
          `GENERATION OF GAME EVENT BY RULE: ${rule.getType()}` +
          `ERROR MESSAGE: ${e && e['message']}`;

        const error = new Error(errorMessage);
        console.error(error);
        throw error;
      }

      if (gameEvent) {
        gameEvents = [...gameEvents, gameEvent];

        updatedGame = produce(game, (draft) => {
          draft.currentEvents = gameEvents;
        });

        skippedEventCount = 0;
      } else {
        skippedEventCount++;
      }
    }

    return gameEvents;
  }

  private checkIfShouldSkipEvent(rule: Rule, game: Game) {
    const isMinDistanceValid = this.checkIsMinDistanceBetweenEventsValid(rule, game);
    if (!isMinDistanceValid) {
      return true;
    }

    const isCountOfEventInMonthValid = this.checkIsEventCountInMonthValid(rule, game);
    if (!isCountOfEventInMonthValid) {
      return true;
    }

    return false;
  }

  private checkIsMinDistanceBetweenEventsValid(rule: Rule, game: Game) {
    const minDistance = rule.getMinDistanceBetweenEvents();
    const gameEvents = game.currentEvents;

    if (minDistance <= 0) {
      return true;
    }

    if (minDistance === 1) {
      const alreadyHaveThisEvent = gameEvents.findIndex((e) => e.type === rule.getType()) >= 0;
      return !alreadyHaveThisEvent;
    }

    const months = game.history?.months ?? [];
    const monthsCount = Math.min(months.length, minDistance);
    const monthsEventHistory = months.slice(-monthsCount);

    const isEventAlreadyHappened = monthsEventHistory.some((month) => {
      return month.events.findIndex((e) => e.type === rule.getType()) >= 0;
    });

    const alreadyHaveThisEventInMonth = gameEvents.findIndex((e) => e.type === rule.getType()) >= 0;

    return !isEventAlreadyHappened && !alreadyHaveThisEventInMonth;
  }

  private checkIsEventCountInMonthValid(rule: Rule, game: Game) {
    const maxCountOfEventInMonth = rule.getMaxCountOfEventInMonth();

    if (maxCountOfEventInMonth <= 0) {
      return true;
    }

    const ruleEvents = game.currentEvents.filter((e) => e.type === rule.getType());
    const isLowerOrEqualToLimit = ruleEvents.length < maxCountOfEventInMonth;

    return isLowerOrEqualToLimit;
  }
}
