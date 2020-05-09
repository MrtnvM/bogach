/// <reference types="@types/jest"/>

import { PossessionStateEntity } from '../../models/domain/possession_state';
import { Possessions } from '../../models/domain/possessions';
import { ParticipantAccountsTransformer } from './participant_accounts_transformer';
import { Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';

const userId: UserEntity.Id = 'user1';

describe('Participant Accounts Transformer Tests', () => {
    test('Generation of possession state', async () => {
        const initialPossesssions: Possessions = {
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

        const game: Game = {
            id: 'game1',
            name: 'Game 1',
            type: 'singleplayer',
            participants: [userId],
            state: {
                gameStatus: 'players_move',
                monthNumber: 1,
                participantProgress: {
                    [userId]: 0,
                },
                winners: {},
            },
            possessions: {
                [userId]: initialPossesssions,
            },
            possessionState: {
                [userId]: PossessionStateEntity.createEmpty(),
            },
            accounts: {
                [userId]: { cashFlow: 10000, cash: 10000, credit: 0 },
            },
            target: { type: 'cash', value: 1000000 },
            currentEvents: [],
        };

        const accountsStateTransformer = new ParticipantAccountsTransformer();
        const newPossessionState = accountsStateTransformer.apply(game);

        expect(newPossessionState.accounts[userId].cashFlow).toStrictEqual(73000);
    });
});
