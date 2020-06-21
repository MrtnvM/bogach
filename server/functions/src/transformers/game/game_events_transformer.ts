import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { GameEvent } from '../../models/domain/game/game_event';
import { GameEventGenerator } from '../../generators/event_generator';

export class GameEventsTransformer extends GameTransformer {
  constructor(private force: boolean = false) {
    super();
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const shouldGenerateEvents = isMoveCompleted || this.force;
    const gameEvents = shouldGenerateEvents ? this.generateGameEvents(game) : game.currentEvents;

    return produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });
  }

  private generateGameEvents(game: Game): GameEvent[] {
    const gameEvents = [
      ...game.currentEvents,
      GameEventGenerator.generateNextEvent(game.currentEvents),
    ];

    return gameEvents;
  }
}
