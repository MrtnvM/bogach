import produce from 'immer';
import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';

export class ParticipantAccountsTransformer extends GameTransformer {
  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    if (!isMoveCompleted) {
      return game;
    }

    const accounts = produce(game.accounts, (draft) => {
      game.participants.forEach((participantId) => {
        const participantAccount = draft[participantId];
        participantAccount.cash += participantAccount.cashFlow;
      });
    });

    return produce(game, (draft) => {
      draft.accounts = accounts;
    });
  }
}
