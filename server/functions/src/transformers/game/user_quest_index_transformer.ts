import { GameTransformer } from './game_transformer';
import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { GameLevelsProvider } from '../../providers/game_levels_provider';

export class UserLevelIndexTransformer extends GameTransformer {
  constructor(private userId: UserEntity.Id) {
    super();
  }

  apply(game: Game): Game {
    const levelName = game.config.level;
    if (levelName == null) {
      return game;
    }

    const isGameCompleted = game.state.gameStatus == 'game_over';
    console.log('isGameCompleted:' + isGameCompleted);

    const isUserWon = game.state.participantsProgress[this.userId].progress >= 1;

    const gameLevels = new GameLevelsProvider().getGameLevels();
    const currentLevelIndex = gameLevels.findIndex((level) => level.id == levelName);

    return isGameCompleted && isQuestGame && isUserWon;

    return updatedGame;
  }
}
