import { GameEventEntity, GameEvent } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';

export namespace NewsEvent {
  export const Type: GameEventEntity.Type = 'news-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly imageUrl: string;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
  }

  export type Info = {
    readonly name: string;
    readonly description: string;
    readonly imageUrl: string;
  };

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'NewsEvent.Data');

    entity.hasStringValue('imageUrl');
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'NewsEvent.PlayerAction'
    );

    entity.hasValue('eventId');
  };
}
