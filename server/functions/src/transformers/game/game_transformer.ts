import { Game } from '../../models/domain/game/game';

export abstract class GameTransformer {
  abstract apply(game: Game): Game;

  isAllParticipantsCompletedMove(game: Game): boolean {
    const isAllParticipantsOnMonthResult = game.participants
      .map((participantId) => {
        const isParticipantCompletedMove =
          game.state.participantsProgress[participantId].status === 'month_result';

        return isParticipantCompletedMove;
      })
      .reduce((prev, curr) => prev && curr, true);

    const isAllParticipantsOnCurrentMonth = game.participants
      .map((participantId) => {
        const currentMonth = game.state.monthNumber;
        const participantMonth =
          game.state.participantsProgress[participantId].currentMonthForParticipant;

        return currentMonth === participantMonth;
      })
      .reduce((prev, curr) => prev && curr, true);

    return isAllParticipantsOnMonthResult && isAllParticipantsOnCurrentMonth;
  }
}
