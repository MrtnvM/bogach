import { GameEventEntity } from '../../models/domain/game/game_event';
import { GameContext } from '../../models/domain/game/game_context';

export abstract class PlayerActionHandler {
  abstract get gameEventType(): GameEventEntity.Type;

  abstract async validate(event: any, action: any): Promise<boolean>;

  abstract async handle(event: any, action: any, context: GameContext): Promise<void>;
}
