import { produce } from 'immer';

import { GameTransformer } from './game_transformer';
import { Game, GameEntity } from '../../models/domain/game/game';
import { GameTargetEntity } from '../../models/domain/game/game_target';

export class WinnersTransformer extends GameTransformer {
  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    const usersProgress = game.participants
      .map((participantId) => ({
        participantId,
        progress: GameTargetEntity.calculateProgress(game, participantId),
      }))
      .sort((p1, p2) => p2.progress - p1.progress);

    const winners: GameEntity.Winner[] = usersProgress.map((p) => ({
      userId: p.participantId,
      targetValue: p.progress,
    }));

    const isTargetArchived = usersProgress[0].progress >= 1;
    const isGameLevelMonthLimitReached = game.config.monthLimit
      ? game.state.monthNumber >= game.config.monthLimit
      : false;

    const shouldCompleteGame =
      isMoveCompleted && (isTargetArchived || isGameLevelMonthLimitReached);

    const gameStatus: GameEntity.Status = shouldCompleteGame ? 'game_over' : game.state.gameStatus;

    return produce(game, (draft) => {
      draft.state.gameStatus = gameStatus;
      draft.state.winners = winners;

      draft.participants.forEach((participantId) => {
        const participantProgress = draft.state.participantsProgress[participantId];
        participantProgress.progress = GameTargetEntity.calculateProgress(game, participantId);
      });
    });
  }
}
