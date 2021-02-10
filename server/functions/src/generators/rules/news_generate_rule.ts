import { Rule, RuleConfig } from '../generator_rule';
import { Game } from '../../models/domain/game/game';
import { NewsEvent } from '../../events/news/news_event';
import { NewsEventGenerator } from '../../events/news/news_event_generator';

export class NewsGenerateRule extends Rule<NewsEvent.Event> {
  constructor(private config: RuleConfig, private newsInfo: NewsEvent.Info[]) {
    super();
  }

  getProbabilityLevel(): number {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return NewsEventGenerator.generate(game, this.newsInfo);
  }

  getMinDistanceBetweenEvents(): number {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxCountOfEventInMonth(): number {
    return this.config.maxCountOfEventInMonth ?? 0;
  }

  getType(): string {
    return NewsEvent.Type;
  }
}
