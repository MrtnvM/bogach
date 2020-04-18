/// <reference types="@types/jest"/>

import { GameProvider } from '../providers/game_provider';
import { mock, instance, when } from 'ts-mockito';
import { GameEntity, Game } from '../models/domain/game/game';
import { UserEntity } from '../models/domain/user';
import { PossessionService } from '../services/possession_service';
import { PossessionState, PossessionStateEntity } from '../models/domain/possession_state';
import { Possessions, PossessionsEntity } from '../models/domain/possessions';
import { InsuranceAsset } from '../models/domain/assets/insurance_asset';
import { DebentureAsset } from '../models/domain/assets/debenture_asset';
import { StockAsset } from '../models/domain/assets/stock_asset';
import { RealtyAsset } from '../models/domain/assets/realty_asset';
import { BusinessAsset } from '../models/domain/assets/business_asset';
import { OtherAsset } from '../models/domain/assets/other_asset';
import { CashAsset } from '../models/domain/assets/cash_asset';
import { MortgageLiability } from '../models/domain/liabilities/mortgage_liability';
import { BusinessCreditLiability } from '../models/domain/liabilities/business_credit';
import { OtherLiability } from '../models/domain/liabilities/other_liability';

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

  const create = <T>(obj: T) => obj;

  test('Generation of possession state', async () => {
    const initialPossesssions: Possessions = {
      incomes: [
        {
          id: 'income1',
          value: 92000,
          name: 'Зарплата',
          type: 'salary'
        },
        {
          id: 'income2',
          value: 1000,
          name: 'Карманные от бабушки',
          type: 'other'
        }
      ],
      expenses: [
        {
          id: 'expense1',
          name: 'Общее',
          value: 20000
        }
      ],
      assets: [
        create<InsuranceAsset>({
          id: 'insurance1',
          name: 'Страховка квартиры',
          type: 'insurance',
          value: 50000,
          downPayment: 5000
        }),
        create<DebentureAsset>({
          id: 'debenture1',
          name: 'ОФЗ',
          type: 'debenture',
          count: 4,
          currentPrice: 1100,
          profitabilityPercent: 8,
          nominal: 1000
        }),
        create<StockAsset>({
          id: 'stocks1',
          name: 'Яндекс',
          maxCount: 1,
          type: 'stocks',
          purchasePrice: 1900
        }),
        create<RealtyAsset>({
          id: 'realty1',
          name: 'Квартира',
          type: 'realty',
          cost: 2000000,
          downPayment: 1000000
        }),
        create<BusinessAsset>({
          id: 'business1',
          name: 'Ларек с шавой',
          type: 'business',
          cost: 200000,
          downPayment: 100000
        }),
        create<OtherAsset>({
          id: 'other_asset1',
          name: 'Биткойны',
          type: 'other',
          value: 30000,
          downPayment: 30000
        }),
        create<CashAsset>({
          id: 'cash1',
          type: 'cash',
          value: 500,
          name: 'Наличные'
        })
      ],
      liabilities: [
        create<MortgageLiability>({
          id: 'mortgage1',
          name: 'Ипотека',
          type: 'mortgage',
          value: 2000000,
          monthlyPayment: 20000
        }),
        create<OtherLiability>({
          id: 'other_libility1',
          name: 'Долг другу',
          type: 'other',
          value: 5000,
          monthlyPayment: 500
        }),
        create<BusinessCreditLiability>({
          id: 'business_credit1',
          value: 40000,
          name: 'Кредит за ларек',
          type: 'business_credit',
          monthlyPayment: 5000
        })
      ]
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
      incomes: [
        {
          value: 92000,
          name: 'Зарплата',
          type: 'salary'
        },
        {
          value: 1000,
          name: 'Карманные от бабушки',
          type: 'other'
        },
        {
          name: 'Облигации',
          type: 'investment',
          value: 320
        }
      ],
      expenses: [
        {
          name: 'Общее',
          value: 20000
        }
      ],
      assets: [
        create<InsuranceAsset>({
          name: 'Страховка квартиры',
          type: 'insurance',
          value: 50000,
          downPayment: 5000
        }),
        create<DebentureAsset>({
          name: 'ОФЗ',
          type: 'debenture',
          count: 4,
          currentPrice: 1100,
          profitabilityPercent: 8,
          nominal: 1000
        }),
        create<StockAsset>({
          name: 'Яндекс',
          maxCount: 1,
          type: 'stocks',
          purchasePrice: 1900
        }),
        create<RealtyAsset>({
          name: 'Квартира',
          type: 'realty',
          cost: 2000000,
          downPayment: 1000000
        }),
        create<BusinessAsset>({
          name: 'Ларек с шавой',
          type: 'business',
          cost: 200000,
          downPayment: 100000
        }),
        create<OtherAsset>({
          name: 'Биткойны',
          type: 'other',
          value: 30000,
          downPayment: 30000
        }),
        create<CashAsset>({
          type: 'cash',
          value: 500,
          name: 'Наличные'
        })
      ],
      liabilities: [
        create<MortgageLiability>({
          name: 'Ипотека',
          type: 'mortgage',
          value: 2000000,
          monthlyPayment: 20000
        }),
        create<OtherLiability>({
          name: 'Долг другу',
          type: 'other',
          value: 5000,
          monthlyPayment: 500
        }),
        create<BusinessCreditLiability>({
          value: 40000,
          name: 'Кредит за ларек',
          type: 'business_credit',
          monthlyPayment: 5000
        })
      ]
    };

    expect(newPossessionState).toStrictEqual(expectedPossessionState);
  });
});
