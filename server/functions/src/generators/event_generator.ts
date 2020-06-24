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
          'ERROR: Incorrect value for probalility level. It should be in interval 0...10 ' +
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

    const gameEvents: GameEvent[] = [];
    const neededGameEventsCount = this.getEventCountForGeneration(game);

    // For preventing infinite loop used counter of iterations of trying generate single game event
    let skippedEventCount = 0;
    const maxEmptyIterationCount = 10_000;

    // For event generation used game updated with generated game events.
    // It's required for concrete game event generator have an ability
    // to modify event content according to already exisiting events in the current month
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
      const minDistance = rule.getMinDistanceBetweenEvents();
      let shouldSkipEvent = false;

      if (minDistance <= 0) {
        shouldSkipEvent = false;
      } else if (minDistance === 1) {
        const alreadyHaveThisEvent = gameEvents.findIndex((e) => e.type === rule.getType()) >= 0;
        shouldSkipEvent = alreadyHaveThisEvent;
      } else {
        const monthsCount = Math.min(game.history.monthEvents.length, minDistance);
        const monthsEventHistory = game.history.monthEvents.slice(-monthsCount);

        const isEventAlreadyHappened = monthsEventHistory.some((monthEvents) => {
          return monthEvents.findIndex((e) => e.type === rule.getType()) >= 0;
        });

        const alreadyHaveThisEvent = gameEvents.findIndex((e) => e.type === rule.getType()) >= 0;

        shouldSkipEvent = isEventAlreadyHappened || alreadyHaveThisEvent;
      }

      if (shouldSkipEvent) {
        skippedEventCount++;
        continue;
      }

      const gameEvent = rule.generate(updatedGame);

      if (gameEvent) {
        gameEvents.push(gameEvent);

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
}
