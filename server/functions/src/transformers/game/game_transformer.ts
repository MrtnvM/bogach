import { Game } from '../../models/domain/game/game';

export abstract class GameTransformer {
  abstract apply(game: Game): Game;

  isAllParticipantsCompletedMove(game: Game): boolean {
    return game.participants
      .map((participantId) => {
        const currentEventNumber = game.state.participantProgress[participantId];
        const isLastEvent = currentEventNumber === game.currentEvents.length - 1;
        return isLastEvent;
      })
      .reduce((prev, curr) => prev && curr, true);
  }
}
