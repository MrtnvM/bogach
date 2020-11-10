import produce from 'immer';
import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';

export class ParticipantAccountsTransformer extends GameTransformer {
  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    const updatedCashFlowAccountsParticipants = produce(game.participants, (draft) => {
      game.participantsIds.forEach((participantId) => {
        const { account, possessionState } = draft[participantId];

        const incomes = possessionState.incomes
          .map((item) => item.value)
          .reduce((previous, current) => previous + current, 0);

        const expenses = possessionState.expenses
          .map((item) => item.value)
          .reduce((previous, current) => previous + current, 0);

        account.cashFlow = incomes - expenses;
      });
    });

    if (!isMoveCompleted) {
      return produce(game, (draft) => {
        draft.participants = updatedCashFlowAccountsParticipants;
      });
    }

    const participants = produce(updatedCashFlowAccountsParticipants, (draft) => {
      game.participantsIds.forEach((participantId) => {
        const participantAccount = draft[participantId].account;
        participantAccount.cash += participantAccount.cashFlow;
      });
    });

    return produce(game, (draft) => {
      draft.participants = participants;
    });
  }
}
