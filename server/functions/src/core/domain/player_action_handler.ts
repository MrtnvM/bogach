import { GameEventEntity } from '../../models/domain/game/game_event';
import { Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';

export abstract class PlayerActionHandler {
  abstract get gameEventType(): GameEventEntity.Type;

  abstract validate(event: any, action: any): Promise<boolean>;

  abstract handle(game: Game, event: any, action: any, userId: UserEntity.Id): Promise<Game>;
}
