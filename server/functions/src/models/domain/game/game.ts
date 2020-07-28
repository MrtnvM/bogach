import { GameEvent } from './game_event';
import { Account } from '../account';
import { UserEntity } from '../user';
import { Possessions } from '../possessions';
import { PossessionState } from '../possession_state';
import { Entity } from '../../../core/domain/entity';
import { GameTarget, GameTargetEntity } from './game_target';
import { ParticipantGameState } from './participant_game_state';
import { GameLevelEntity } from '../../../game_levels/models/game_level';

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
  readonly history: GameEntity.History;

  readonly config: GameEntity.Config;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace GameEntity {
  export type Id = string;
  export type Type = 'singleplayer' | 'multiplayer';
  export type GameEventIndex = number;

  export type Status = 'players_move' | 'game_over';
  const GameStatusValues = ['players_move', 'game_over'];

  export type MonthResult = {
    readonly cash: number;
    readonly totalIncome: number;
    readonly totalExpense: number;
    readonly totalAssets: number;
    readonly totalLiabilities: number;
  };

  export type ParticipantProgress = {
    readonly currentEventIndex: number;
    readonly currentMonthForParticipant: number;
    readonly status: 'player_move' | 'month_result';
    readonly monthResults: { [month: number]: MonthResult };
    readonly progress: number;
  };

  export type State = {
    readonly gameStatus: Status;
    readonly monthNumber: number;
    readonly participantsProgress: { [userId: string]: ParticipantProgress };
    readonly winners: { [place: number]: UserEntity.Id };
  };

  export type History = {
    months: { events: GameEvent[] }[];
  };

  export type Config = {
    readonly level?: GameLevelEntity.Id;
    readonly monthLimit?: number;
    readonly stocks: string[];
    readonly debentures: string[];
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

    stateEntity.checkUnion('gameStatus', GameStatusValues);
    stateEntity.hasNumberValue('monthNumber');
    stateEntity.hasValuesForKeys('participantsProgress', gameEntity.participants);
  };

  export const getPastEventsOfType = <T extends GameEvent>(props: {
    game: Game;
    type: string;
    maxHistoryLength: number;
  }): T[] => {
    const { game, type, maxHistoryLength } = props;
    const historyLength = Math.min(game.history.months.length, maxHistoryLength);
    const history = game.history.months.slice(-historyLength);

    const pastEvents = history
      .map((month) => month.events.filter((e) => e.type === type))
      .reduce((allEvents, monthEvents) => [...monthEvents.reverse(), ...allEvents], [])
      .map((e) => e as T);

    return pastEvents;
  };
}
