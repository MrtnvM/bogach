import { Game } from '../../models/domain/game/game';

export abstract class GameTransformer {
  abstract apply(game: Game): Game;

  isAllParticipantsCompletedMove(game: Game): boolean {
    return game.participants
      .map((participantId) => {
        const isParticipantCompletedMove =
          game.state.participantsProgress[participantId].status === 'month_result';
        return isParticipantCompletedMove;
      })
      .reduce((prev, curr) => prev && curr, true);
  }
}
