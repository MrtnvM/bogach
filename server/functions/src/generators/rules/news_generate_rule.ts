import { Rule, RuleConfig } from '../generator_rule';
import { Game } from '../../models/domain/game/game';
import { NewsEvent } from '../../events/news/news_event';
import { NewsEventGenerator } from '../../events/news/news_event_generator';

export class NewsGenerateRule extends Rule<NewsEvent.Event> {
  constructor(private config: RuleConfig, private newsInfo: NewsEvent.Info[]) {
    super();
  }

  getProbabilityLevel() {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return NewsEventGenerator.generate(game, this.newsInfo);
  }

  getMinDistanceBetweenEvents() {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }

  getMaxHistoryLength(): number {
    // For news generation another algorithm will be used
    throw new Error('Method not implemented.');
  }

  getType() {
    return NewsEvent.Type;
  }
}
