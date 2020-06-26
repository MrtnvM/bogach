import { GameEvent, GameEventEntity } from '../../models/domain/game/game_event';
import { Entity } from '../../core/domain/entity';

export namespace IncomeEvent {
  export const Type: GameEventEntity.Type = 'income-event';

  export type Event = GameEvent<Data>;

  export interface Data {
    readonly income: number;
  }

  export type PlayerAction = {};

  export const validate = (event: any) => {
    if (event?.type !== Type) {
      throw new Error('ERROR: Event type is not equal to ' + Type);
    }

    const entity = Entity.createEntityValidator<Data>(event.data, 'IncomeEvent.Data');

    entity.hasNumberValue('income');

    entity.checkWithRules([[(a) => a.income <= 0, "Income can't be <= 0"]]);
  };

  export const validateAction = (action: any) => undefined;
}
