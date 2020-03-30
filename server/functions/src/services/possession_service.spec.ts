/// <reference types="@types/jest"/>

import { GameProvider } from '../providers/game_provider';
import { mock, instance, when } from 'ts-mockito';
import { GameEntity, Game } from '../models/domain/game/game';
import { UserEntity } from '../models/domain/user';
import { PossessionService } from '../services/possession_service';
import { PossessionState, PossessionStateEntity } from '../models/domain/possession_state';
import { Possessions, PossessionsEntity } from '../models/domain/possessions';

describe('Possession Service Tests', () => {
  const gameId: GameEntity.Id = 'game1';
  const userId: UserEntity.Id = 'user1';

  const game: Game = {
    id: gameId,
    name: 'Game 1',
    participants: [userId],
    possessions: { [userId]: PossessionsEntity.createEmpty() },
    possessionState: {
      [userId]: PossessionStateEntity.createEmpty()
    },
    accounts: {},
    target: { type: 'cash', value: 1000000 },
    currentEvents: []
  };

  test('Generation of possession state', async () => {
    const initialPossesssions: Possessions = {
      incomes: [],
      expenses: [],
      assets: [],
      liabilities: []
    };

    const mockedGameProvider: GameProvider = mock(GameProvider);

    when(mockedGameProvider.getGame(gameId)).thenResolve({
      ...game,
      possessions: { [userId]: initialPossesssions }
    });

    const gameProvider: GameProvider = instance(mockedGameProvider);
    const possessionService = new PossessionService(gameProvider);
    const newPossessionState = await possessionService.generatePossessionState(initialPossesssions);

    const expectedPossessionState: PossessionState = {
      incomes: [],
      expenses: [],
      assets: [],
      liabilities: []
    };

    expect(newPossessionState).toStrictEqual(expectedPossessionState);
  });
});
