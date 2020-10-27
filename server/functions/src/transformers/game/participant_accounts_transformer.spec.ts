/// <reference types="@types/jest"/>

import { PossessionState } from '../../models/domain/possession_state';
import { Possessions } from '../../models/domain/possessions';
import { ParticipantAccountsTransformer } from './participant_accounts_transformer';
import { Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { GameFixture } from '../../core/fixtures/game_fixture';

const userId: UserEntity.Id = 'user1';

describe('Participant Accounts Transformer Tests', () => {
  test('Positive cashflow count', async () => {
    const possessionState: PossessionState = {
      incomes: [
        {
          id: 'income1',
          value: 92000,
          name: 'Зарплата',
          type: 'salary',
        },
        {
          id: 'income2',
          value: 1000,
          name: 'Карманные от бабушки',
          type: 'other',
        },
      ],
      expenses: [
        {
          id: 'expense1',
          name: 'Общее',
          value: 20000,
        },
      ],
      assets: [],
      liabilities: [],
    };

    const game = buildGameEntity(possessionState);

    const accountsStateTransformer = new ParticipantAccountsTransformer();
    const newGameState = accountsStateTransformer.apply(game);

    expect(newGameState.accounts[userId].cashFlow).toStrictEqual(73000);
  });

  test('Negative cashflow count', async () => {
    const possessionState: PossessionState = {
      incomes: [
        {
          id: 'income2',
          value: 1000,
          name: 'Карманные от бабушки',
          type: 'other',
        },
      ],
      expenses: [
        {
          id: 'expense1',
          name: 'Общее',
          value: 20000,
        },
      ],
      assets: [],
      liabilities: [],
    };

    const game = buildGameEntity(possessionState);

    const accountsStateTransformer = new ParticipantAccountsTransformer();
    const newGameState = accountsStateTransformer.apply(game);

    expect(newGameState.accounts[userId].cashFlow).toStrictEqual(-19000);
  });

  test('Empty cashflow count', async () => {
    const possessionState: PossessionState = {
      incomes: [],
      expenses: [],
      assets: [],
      liabilities: [],
    };

    const game = buildGameEntity(possessionState);

    const accountsStateTransformer = new ParticipantAccountsTransformer();
    const newGameState = accountsStateTransformer.apply(game);

    expect(newGameState.accounts[userId].cashFlow).toStrictEqual(0);
  });

  test('Int overflow cashflow count', async () => {
    const possessionState: PossessionState = {
      incomes: [
        {
          id: 'income2',
          value: 1000000000000000,
          name: 'Карманные от бабушки',
          type: 'other',
        },
      ],
      expenses: [
        {
          id: 'expense1',
          name: 'Общее',
          value: 2000000000000000,
        },
      ],
      assets: [],
      liabilities: [],
    };

    const game = buildGameEntity(possessionState);

    const accountsStateTransformer = new ParticipantAccountsTransformer();
    const newGameState = accountsStateTransformer.apply(game);

    expect(newGameState.accounts[userId].cashFlow).toStrictEqual(-1000000000000000);
  });

  test('Empty expenses cashflow count', async () => {
    const possessionState: PossessionState = {
      incomes: [
        {
          id: 'income2',
          value: 1000,
          name: 'Карманные от бабушки',
          type: 'other',
        },
      ],
      expenses: [],
      assets: [],
      liabilities: [],
    };

    const game = buildGameEntity(possessionState);

    const accountsStateTransformer = new ParticipantAccountsTransformer();
    const newGameState = accountsStateTransformer.apply(game);

    expect(newGameState.accounts[userId].cashFlow).toStrictEqual(1000);
  });

  test('Empty incomes cashflow count', async () => {
    const possessionState: PossessionState = {
      incomes: [],
      expenses: [
        {
          id: 'expense1',
          name: 'Общее',
          value: 1000,
        },
      ],
      assets: [],
      liabilities: [],
    };

    const game = buildGameEntity(possessionState);

    const accountsStateTransformer = new ParticipantAccountsTransformer();
    const newGameState = accountsStateTransformer.apply(game);

    expect(newGameState.accounts[userId].cashFlow).toStrictEqual(-1000);
  });
});

function buildGameEntity(possessionState: PossessionState) {
  const initialPossesssions: Possessions = {
    incomes: [],
    expenses: [],
    assets: [],
    liabilities: [],
  };

  const game: Game = GameFixture.createGame({
    id: 'game1',
    participants: [userId],
    possessions: {
      [userId]: initialPossesssions,
    },
    possessionState: {
      [userId]: possessionState,
    },
    accounts: {
      [userId]: { cashFlow: 10000, cash: 10000, credit: 0 },
    },
  });

  return game;
}
