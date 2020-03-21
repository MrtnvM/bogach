import { GameEventType } from '../../models/domain/game_event';
import { PlayerAction } from '../../models/domain/player_action';

export abstract class PlayerActionHandler<T, P = {}> {
  abstract get gameEventType(): GameEventType;

  abstract async validate(event: T): Promise<boolean>;

  abstract async handle(event: PlayerAction<T, P>): Promise<void>;
}
