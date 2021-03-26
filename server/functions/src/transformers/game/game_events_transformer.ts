import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { GameEvent } from '../../models/domain/game/game_event';
import { GameEventGenerator } from '../../generators/game_event_generator';
import { GameLevels } from '../../game_levels/game_levels';
import { Rule } from '../../generators/generator_rule';
import { GameRulesProvider } from '../../providers/game_rules_provider';

export class GameEventsTransformer extends GameTransformer {
  constructor(private force: boolean = false) {
    super();
  }

  transformerContext() {
    return { name: 'GameEventsTransformer', force: this.force };
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const shouldGenerateEvents = isMoveCompleted || this.force;

    let gameEvents = game.currentEvents;
    const ruleProvider = new GameRulesProvider();
    const rules = ruleProvider.getRulesForGame(game);

    if (shouldGenerateEvents) {
      gameEvents = this.generateGameEvents(game, rules);
    }

    return produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });
  }

  private generateGameEvents(game: Game, rules: Rule[]): GameEvent[] {
    const levelId = game.config.level;
    const level = levelId && GameLevels.levelsMap[levelId];

    if (level) {
      const index = this.force ? 0 : game.state.monthNumber;
      const levelGameEvents = level.levelEventConfig.events[index];
      return levelGameEvents ?? [];
    }

    const gameEventGenerator = new GameEventGenerator({ rules });
    const gameEvents = gameEventGenerator.generateEvents(game);

    return gameEvents;
  }
}
