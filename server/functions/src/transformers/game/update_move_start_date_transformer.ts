import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';

export class UpdateMoveStartDateTransformer extends GameTransformer {
  constructor(private force: boolean = false) {
    super();
  }

  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const isSingleplayerGame = game.type === 'singleplayer';

    if (isSingleplayerGame || (!isMoveCompleted && !this.force)) {
      return game;
    }

    const updatedGame = produce(game, (draft) => {
      draft.state.moveStartDateInUTC = new Date().toISOString();
    });

    return updatedGame;
  }
}
