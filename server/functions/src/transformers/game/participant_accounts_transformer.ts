import produce from 'immer';
import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';

export class ParticipantAccountsTransformer extends GameTransformer {
  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    const participants = produce(game.participants, (draft) => {
      draft.forEach((participantId) => {

        const incomes = game.possessionState[participantId].incomes
          .map((item) => { return item.value })
          .reduce((previous, current) => previous + current);

        const expenses = game.possessionState[participantId].expenses
          .map((item) => { return item.value })
          .reduce((previous, current) => previous + current);

        return incomes + expenses;
      });
    });

    if (!isMoveCompleted) {
      return produce(game, (draft) => {
        draft.participants = participants;
      });
    }

    const accounts = produce(game.accounts, (draft) => {
      game.participants.forEach((participantId) => {
        const participantAccount = draft[participantId];
        participantAccount.cash += participantAccount.cashFlow;
      });
    });

    return produce(game, (draft) => {
      draft.accounts = accounts;
      draft.participants = participants;
    });
  }
}
