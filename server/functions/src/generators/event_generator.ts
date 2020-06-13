import { GameEvent } from '../models/domain/game/game_event';
import { Rule } from './generator_rule';
import { DebentureRule } from './rules/debenture_generate_rule';

export namespace GameEvenGenerator {
  const rules: Rule<any>[] = [new DebentureRule()];
  const allProbability: number = rules.reduce((prev, cur) => prev + cur.getPercentage(), 0);

  export const generateNextEvent = (events: GameEvent[]): GameEvent => {
    let event: GameEvent | null = null!;

    while (event === null) {
      event = generateEvent(events);
    }

    return event;
  };

  const generateEvent = (events: GameEvent[]): GameEvent | null => {
    const rule: Rule<any> = findRule(events);
    const distanceDoable = isDistanceDoable(events, rule);

    if (distanceDoable && rule.canGenerate(events)) {
      return rule.generate();
    }

    return null;
  };

  const findRule = (events: GameEvent[]): Rule<any> => {
    let randomNumber: number = Math.random() * allProbability;

    for (let rule of rules) {
      randomNumber -= rule.getPercentage();

      if (randomNumber <= 0) {
        return rule;
      }
    }

    // Won't be called in the correct implementation
    return rules[0];
  };

  const isDistanceDoable = (events: GameEvent[], rule: Rule<any>): boolean => {
    const minDuration: number = rule.getMinDuration();
    const start: number = events.length - minDuration < 0 ? 0 : events.length - minDuration;
    const end: number = events.length;
    return events.slice(start, end).find((item) => item.type === rule.getType()) !== undefined;
  };
}
