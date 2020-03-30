import { GameEvent } from './game_event';
import { Account } from '../account';
import { UserId } from '../user';
import { Possessions } from '../possessions';
import { PossessionState } from '../possession_state';
import { Entity } from '../../../core/domain/entity';
import { GameTarget, GameTargetEntity } from './game_target';
import { GameState } from './game_state';

export interface Game {
  readonly id: GameEntity.Id;
  readonly name: string;
  readonly participants: UserId[];
  readonly possessions: GameState<Possessions>;
  readonly possessionState: GameState<PossessionState>;
  readonly accounts: GameState<Account>;
  readonly target: GameTarget;
  readonly currentEvents: GameEvent[];

  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace GameEntity {
  export type Id = string;

  export const parse = (data: any): Game => {
    const {
      id,
      name,
      participants,
      possessions,
      possessionState,
      accounts,
      target,
      currentEvents,
      createdAt,
      updatedAt
    } = data;

    let game: Game = {
      id,
      name,
      participants,
      possessions,
      possessionState,
      accounts,
      target,
      currentEvents,
      createdAt,
      updatedAt
    };

    validate(game);
    return game;
  };

  export const validate = (game: any) => {
    const entity = Entity.createEntityValidator<Game>(game, 'Game');

    entity.hasValue('id');
    entity.hasValue('name');
    entity.hasValue('participants');
    // entity.hasValue('possessions');
    // entity.hasValue('possessionState');
    entity.hasValue('accounts');
    entity.hasValue('target');
    entity.hasValue('currentEvents');

    const gameEntity = game as Game;
    GameTargetEntity.validate(gameEntity.target);
  };
}
