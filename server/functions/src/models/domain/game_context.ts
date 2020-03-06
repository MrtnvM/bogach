import { UserId } from './user';
import { GameId } from './game';
import { Entity } from '../../core/domain/entity';

export interface GameContext {
  gameId: GameId;
  userId: UserId;
}

export namespace GameContextEntity {
  export const parse = (data: any): GameContext => {
    const gameContext = {
      gameId: data['game_id'],
      userId: data['user_id']
    };

    validate(gameContext);

    return gameContext;
  };

  export const validate = (gameContext: any) => {
    const entity = Entity.createEntityValidator<GameContext>(gameContext);

    entity.hasValue('userId');
    entity.hasValue('gameId');
  };
}
