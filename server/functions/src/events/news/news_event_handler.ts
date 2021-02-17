import { Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { NewsEvent } from './news_event';

type Event = NewsEvent.Event;
type Action = NewsEvent.PlayerAction;

export class NewsEventHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return NewsEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      NewsEvent.validate(event);
      NewsEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    return game;
  }
}
