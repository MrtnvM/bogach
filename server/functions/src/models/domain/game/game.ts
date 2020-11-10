import { GameEvent } from './game_event';
import { Account, AccountEntity } from '../account';
import { Possessions, PossessionsEntity } from '../possessions';
import { PossessionState } from '../possession_state';
import { Entity } from '../../../core/domain/entity';
import { GameTarget, GameTargetEntity } from './game_target';
import { GameLevelEntity } from '../../../game_levels/models/game_level';
import { DebentureEvent } from '../../../events/debenture/debenture_event';
import { UserEntity } from '../user/user';
import { AssetEntity } from '../asset';

export interface Game {
  readonly id: GameEntity.Id;
  readonly name: string;
  readonly type: GameEntity.Type;
  readonly state: GameEntity.State;
  readonly participantsIds: UserEntity.Id[];
  readonly participants: { [userId: string]: GameEntity.Participant };
  readonly target: GameTarget;
  readonly currentEvents: GameEvent[];
  readonly history: GameEntity.History;

  readonly config: GameEntity.Config;
  readonly createdAt?: string;
  readonly updatedAt?: string;
}

export namespace GameEntity {
  export type Id = string;
  export type Type = 'singleplayer' | 'multiplayer';
  export type GameEventIndex = number;

  export type Status = 'players_move' | 'game_over';
  const GameStatusValues = ['players_move', 'game_over'];

  export type ParticipantProgressStatus = 'player_move' | 'month_result';
  const ParticipantProgressStatusValues = ['player_move', 'month_result'];

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
    readonly status: ParticipantProgressStatus;
    readonly monthResults: { [month: number]: MonthResult };
    readonly progress: number;
  };

  export type Participant = {
    readonly id: string;
    readonly progress: ParticipantProgress;
    readonly possessions: Possessions;
    readonly possessionState: PossessionState;
    readonly account: Account;
  };

  export const initialParticipantProgress = (
    possessionState: PossessionState,
    account: Account
  ) => {
    const { incomes, expenses, assets, liabilities } = possessionState;

    const totalIncome = incomes.reduce((total, income) => total + income.value, 0);
    const totalExpense = expenses.reduce((total, expense) => total + expense.value, 0);

    const totalAssets = assets
      .map(AssetEntity.getAssetValue)
      .reduce((total, assetValue) => total + assetValue, 0);

    const totalLiabilities = liabilities.reduce((total, liability) => total + liability.value, 0);

    const monthResult: GameEntity.MonthResult = {
      cash: account.cash,
      totalIncome,
      totalExpense,
      totalAssets,
      totalLiabilities,
    };

    const participantsProgress: ParticipantProgress = {
      currentEventIndex: 0,
      currentMonthForParticipant: 1,
      status: 'player_move',
      monthResults: { 0: monthResult },
      progress: 0,
    };

    return participantsProgress;
  };

  export type State = {
    readonly gameStatus: Status;
    readonly monthNumber: number;
    readonly moveStartDateInUTC: string;
    readonly winners: Winner[];
  };

  export type Winner = {
    readonly userId: UserEntity.Id;
    readonly targetValue: number;
  };

  export type History = {
    months: { events: GameEvent[] }[];
  };

  export type Config = {
    readonly level?: GameLevelEntity.Id | null;
    readonly monthLimit?: number | null;
    readonly stocks: string[];
    readonly debentures: DebentureEvent.Info[];
    readonly initialCash: number;
    readonly gameTemplateId: string;
  };

  export const validate = (game: any) => {
    const entity = Entity.createEntityValidator<Game>(game, 'Game');

    entity.hasValue('id');
    entity.hasValue('name');
    entity.hasValue('type');
    entity.hasValue('state');
    entity.hasValue('participants');
    entity.hasValue('participantsIds');
    entity.hasObjectValue('target', GameTargetEntity.validate);
    entity.hasValue('currentEvents');

    const gameEntity = game as Game;
    const stateEntity = Entity.createEntityValidator<State>(gameEntity.state, 'Game State');

    stateEntity.checkUnion('gameStatus', GameStatusValues);
    stateEntity.hasNumberValue('monthNumber');
    stateEntity.hasValue('moveStartDateInUTC');
    stateEntity.hasValue('winners');

    const participantsIds = Object.keys(gameEntity.participants);
    participantsIds.sort();
    gameEntity.participantsIds.sort();

    if (JSON.stringify(participantsIds) !== JSON.stringify(gameEntity.participantsIds)) {
      throw Error(
        'Participants ids is not the same as in the participantIds\n' +
          `[participantIds] = ${JSON.stringify(gameEntity.participantsIds)}\n` +
          `[participants] = ${JSON.stringify(participantsIds)}`
      );
    }

    participantsIds.forEach((id) => {
      const participant = gameEntity.participants[id];
      const participantEntity = Entity.createEntityValidator<GameEntity.Participant>(
        participant,
        'Game Participant'
      );

      participantEntity.hasStringValue('id');
      participantEntity.hasObjectValue('possessions', PossessionsEntity.validate);
      participantEntity.hasObjectValue('possessionState', PossessionsEntity.validate);
      participantEntity.hasObjectValue('account', AccountEntity.validate);
      participantEntity.hasValue('progress');

      const progressEntity = Entity.createEntityValidator<GameEntity.ParticipantProgress>(
        participant.progress,
        'Game Participant Progress'
      );
      progressEntity.hasNumberValue('currentEventIndex');
      progressEntity.hasNumberValue('currentMonthForParticipant');
      progressEntity.hasStringValue('status');
      progressEntity.checkUnion('status', ParticipantProgressStatusValues);
      progressEntity.hasNumberValue('progress');
    });
  };

  export const getPastEventsOfType = <T extends GameEvent>(props: {
    game: Game;
    type: string;
    maxHistoryLength: number;
  }): T[] => {
    const { game, type, maxHistoryLength } = props;

    const months = game.history?.months || [];
    const historyLength = Math.min(months.length, maxHistoryLength);
    const monthsHistory = months.slice(-historyLength);

    const pastEvents = monthsHistory
      .map((month) => month.events.filter((e) => e.type === type))
      .reduce((allEvents, monthEvents) => [...monthEvents.reverse(), ...allEvents], [])
      .map((e) => e as T);

    return pastEvents;
  };

  export const getLastEventOfType = <T extends GameEvent>(props: {
    game: Game;
    type: string;
  }): T | undefined => {
    const { game, type } = props;

    const months = (game.history?.months || []).reverse();

    let event: T | undefined = undefined;

    for (const month of months) {
      for (const e of month?.events ?? []) {
        if (e.type === type) {
          event = e as T;
          break;
        }
      }

      if (event) {
        break;
      }
    }

    return event;
  };
}
