import { GameEvent } from './game_event';
import { Account } from '../account';
import { UserEntity } from '../user';
import { Possessions } from '../possessions';
import { PossessionState } from '../possession_state';
import { Entity } from '../../../core/domain/entity';
import { GameTarget, GameTargetEntity } from './game_target';
import { ParticipantGameState } from './participant_game_state';

export interface Game {
  readonly id: GameEntity.Id;
  readonly name: string;
  readonly type: GameEntity.Type;
  readonly state: GameEntity.State;
  readonly participants: UserEntity.Id[];
  readonly possessions: ParticipantGameState<Possessions>;
  readonly possessionState: ParticipantGameState<PossessionState>;
  readonly accounts: ParticipantGameState<Account>;
  readonly target: GameTarget;
  readonly currentEvents: GameEvent[];

  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace GameEntity {
  export type Id = string;

  export type Type = 'singleplayer' | 'multiplayer';
  export type Status = 'players_move' | 'game_over';
  export type GameEventIndex = number;

  export type MonthResult = {
    cash: number;
    totalIncome: number;
    totalExpense: number;
    totalAssets: number;
    totalLiabilities: number;
  };

  export type ParticipantProgress = {
    currentEventIndex: number;
    status: 'player_move' | 'month_result';
    monthResults: { [month: number]: MonthResult };
  };

  export type State = {
    readonly gameStatus: Status;
    readonly monthNumber: number;
    readonly participantProgress: { [userId: string]: GameEventIndex };
    readonly participantsProgress: { [userId: string]: ParticipantProgress };
    readonly winners: { [place: number]: UserEntity.Id };
  };

  const GameStateValues = ['players_move', 'game_over'];

  export const parse = (data: any): Game => {
    const {
      id,
      name,
      type,
      state,
      participants,
      possessions,
      possessionState,
      accounts,
      target,
      currentEvents,
      createdAt,
      updatedAt,
    } = data;

    const game: Game = {
      id,
      name,
      type,
      state,
      participants,
      possessions,
      possessionState,
      accounts,
      target,
      currentEvents,
      createdAt,
      updatedAt,
    };

    validate(game);
    return game;
  };

  export const validate = (game: any) => {
    const entity = Entity.createEntityValidator<Game>(game, 'Game');

    entity.hasValue('id');
    entity.hasValue('name');
    entity.hasValue('type');
    entity.hasValue('state');
    entity.hasValue('participants');
    entity.hasValue('possessions');
    entity.hasValue('possessionState');
    entity.hasValue('accounts');
    entity.hasObjectValue('target', GameTargetEntity.validate);
    entity.hasValue('currentEvents');

    const gameEntity = game as Game;

    entity.hasValuesForKeys('possessions', gameEntity.participants);
    entity.hasValuesForKeys('possessionState', gameEntity.participants);
    entity.hasValuesForKeys('accounts', gameEntity.participants);

    const stateEntity = Entity.createEntityValidator<State>(gameEntity.state, 'Game State');

    stateEntity.checkUnion('gameStatus', GameStateValues);
    stateEntity.hasNumberValue('monthNumber');
    stateEntity.hasValuesForKeys('participantProgress', gameEntity.participants);
  };
}
