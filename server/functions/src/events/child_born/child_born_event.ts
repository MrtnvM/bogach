import { GameEventEntity, GameEvent } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';

export namespace ChildBornEvent {
  export const Type: GameEventEntity.Type = 'child-born-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly monthlyPayment: number;
  }

  export interface PlayerAction {
    readonly eventId: GameEventEntity.Id;
  }

  export const parse = (gameEvent: GameEvent, eventData: any): Event => {
    const { monthlyPayment } = eventData.data;

    return {
      ...gameEvent,
      data: {
        monthlyPayment,
      },
    };
  };

  export const validate = (event: any) => {
    if (event.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'ChildBornEvent.Data');

    entity.hasNumberValue('monthlyPayment');

    entity.checkWithRules([[(a) => a.monthlyPayment < 0, "Monthly payment can't be <= 0"]]);
  };

  export const validateAction = (action: any) => {
    const entity = Entity.createEntityValidator<PlayerAction>(
      action,
      'ChildBornEvent.PlayerAction'
    );

    entity.hasValue('eventId');
  };
}
