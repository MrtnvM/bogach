import { Entity } from '../../../core/domain/entity';

export interface GameEvent<EventData = any> {
  readonly id: GameEventEntity.Id;
  readonly name: string;
  readonly description: string;
  readonly image?: string | null;
  readonly type: GameEventEntity.Type;
  readonly data: EventData;
}

export namespace GameEventEntity {
  export type Id = string;
  export type Type = string;

  export const validate = (gameEvent: any) => {
    const entity = Entity.createEntityValidator<GameEvent>(gameEvent, 'Game Event');

    entity.hasValue('id');
    entity.hasValue('name');
    entity.hasValue('description');
    entity.hasValue('type');
  };
}
