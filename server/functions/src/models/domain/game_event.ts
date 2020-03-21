import * as uuid from 'uuid';
import { Entity } from '../../core/domain/entity';
import { DebenturePriceChangedEvent } from '../../events/debenture/debenture_price_changed_event';

export type GameEventId = string;
export type GameEventType = string;

export interface GameEvent<EventData = any> {
  readonly id: GameEventId;
  readonly name: string;
  readonly description: string;
  readonly type: GameEventType;
  readonly data: EventData;
}

export namespace GameEventEntity {
  export const create = <T>(
    name: string,
    description: string,
    type: GameEventType,
    data: T
  ): GameEvent<T> => {
    const newGameEvent = {
      id: uuid.v4(),
      name,
      description,
      type,
      data
    };

    validate(newGameEvent);
    return newGameEvent;
  };

  export const parse = (eventData: any): GameEvent => {
    const { id, name, description, type } = eventData;
    let gameEvent: GameEvent = { id, name, description, type, data: {} };

    gameEvent = Entity.parse(gameEvent, eventData, gameEvent.type, [
      [DebenturePriceChangedEvent.Id, DebenturePriceChangedEvent.parse]
    ]);

    validate(gameEvent);
    return gameEvent;
  };

  export const validate = (gameEvent: any) => {
    const entity = Entity.createEntityValidator<GameEvent>(gameEvent);

    entity.hasValue('id');
    entity.hasValue('name');
    entity.hasValue('description');
    entity.hasValue('type');

    const type = gameEvent.type;

    Entity.validate(gameEvent, type, [
      [DebenturePriceChangedEvent.Id, DebenturePriceChangedEvent.validate]
    ]);
  };
}
