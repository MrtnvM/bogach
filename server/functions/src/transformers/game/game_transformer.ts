import { Game } from '../../models/domain/game/game';

export abstract class GameTransformer {
  abstract apply(game: Game): Game;

  isAllParticipantsCompletedMove(game: Game): boolean {
    const isAllParticipantsOnMonthResult = game.participantsIds
      .map((participantId) => {
        const participant = game.participants[participantId];
        const isParticipantCompletedMove = participant.progress.status === 'month_result';
        return isParticipantCompletedMove;
      })
      .reduce((prev, curr) => prev && curr, true);

    const isAllParticipantsOnCurrentMonth = game.participantsIds
      .map((participantId) => {
        const participant = game.participants[participantId];
        const currentMonth = game.state.monthNumber;
        const participantMonth = participant.progress.currentMonthForParticipant;
        const isTheSameMonth = currentMonth === participantMonth;
        return isTheSameMonth;
      })
      .reduce((prev, curr) => prev && curr, true);

    return isAllParticipantsOnMonthResult && isAllParticipantsOnCurrentMonth;
  }
}
