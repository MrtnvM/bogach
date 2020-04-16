import * as uuid from 'uuid';
import { Entity } from '../../../core/domain/entity';
import { DebenturePriceChangedEvent } from '../../../events/debenture/debenture_price_changed_event';

export interface GameEvent<EventData = any> {
  readonly id: GameEventEntity.Id;
  readonly name: string;
  readonly description: string;
  readonly type: GameEventEntity.Type;
  readonly data: EventData;
}

export namespace GameEventEntity {
  export type Id = string;
  export type Type = string;

  export const create = <T>(
    name: string,
    description: string,
    type: Type,
    data: T
  ): GameEvent<T> => {
    const newGameEvent = {
      id: uuid.v4(),
      name,
      description,
      type,
      data,
    };

    validate(newGameEvent);
    return newGameEvent;
  };

  export const parse = (eventData: any): GameEvent => {
    const { id, name, description, type } = eventData;
    let gameEvent: GameEvent = { id, name, description, type, data: {} };

    gameEvent = Entity.parse(gameEvent, eventData, gameEvent.type, [
      [DebenturePriceChangedEvent.Type, DebenturePriceChangedEvent.parse],
    ]);

    validate(gameEvent);
    return gameEvent;
  };

  export const validate = (gameEvent: any) => {
    const entity = Entity.createEntityValidator<GameEvent>(gameEvent, 'Game Event');

    entity.hasValue('id');
    entity.hasValue('name');
    entity.hasValue('description');
    entity.hasValue('type');

    const type = gameEvent.type;

    Entity.validate(gameEvent, type, [
      [DebenturePriceChangedEvent.Type, DebenturePriceChangedEvent.validate],
    ]);
  };
}
