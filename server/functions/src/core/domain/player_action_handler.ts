import { GameEventType } from '../../models/domain/game/game_event';
import { GameContext } from '../../models/domain/game/game_context';

export abstract class PlayerActionHandler<Event, Action = {}> {
  abstract get gameEventType(): GameEventType;

  abstract async validate(event: Event, action: Action): Promise<boolean>;

  abstract async handle(event: Event, action: Action, context: GameContext): Promise<void>;
}
