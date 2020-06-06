/// <reference types="@types/jest"/>

import { PossessionState } from '../../models/domain/possession_state';
import { Possessions } from '../../models/domain/possessions';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { StockAsset } from '../../models/domain/assets/stock_asset';
import { RealtyAsset } from '../../models/domain/assets/realty_asset';
import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { OtherAsset } from '../../models/domain/assets/other_asset';
import { CashAsset } from '../../models/domain/assets/cash_asset';
import { MortgageLiability } from '../../models/domain/liabilities/mortgage_liability';
import { BusinessCreditLiability } from '../../models/domain/liabilities/business_credit';
import { OtherLiability } from '../../models/domain/liabilities/other_liability';
import { PossessionStateTransformer } from './possession_state_transformer';

describe('Possession Service Tests', () => {
  const create = <T>(obj: T) => obj;

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
      assets: [
        create<InsuranceAsset>({
          id: 'insurance1',
          name: 'Страховка квартиры',
          type: 'insurance',
          value: 50000,
          cost: 5000,
          duration: 12,
          fromMonth: 1,
          insuranceType: 'health',
        }),
        create<DebentureAsset>({
          id: 'debenture1',
          name: 'ОФЗ',
          type: 'debenture',
          count: 4,
          averagePrice: 1100,
          profitabilityPercent: 8,
          nominal: 1000,
        }),
        create<StockAsset>({
          id: 'stocks1',
          name: 'Яндекс',
          countInPortfolio: 1,
          type: 'stock',
          fairPrice: 100,
          averagePrice: 100,
        }),
        create<RealtyAsset>({
          id: 'realty1',
          name: 'Квартира',
          type: 'realty',
          cost: 2000000,
          downPayment: 1000000,
        }),
        create<BusinessAsset>({
          id: 'business1',
          name: 'Ларек с шавой',
          type: 'business',
          fairPrice: 200_000,
          downPayment: 100_000,
          buyPrice: 210_000,
          payback: 20,
          passiveIncomePerMonth: 2000,
          sellProbability: 5,
        }),
        create<OtherAsset>({
          id: 'other_asset1',
          name: 'Биткойны',
          type: 'other',
          value: 30000,
          downPayment: 30000,
        }),
        create<CashAsset>({
          id: 'cash1',
          type: 'cash',
          value: 500,
          name: 'Наличные',
        }),
      ],
      liabilities: [
        create<MortgageLiability>({
          id: 'mortgage1',
          name: 'Ипотека',
          type: 'mortgage',
          value: 2000000,
          monthlyPayment: 20000,
        }),
        create<OtherLiability>({
          id: 'other_libility1',
          name: 'Долг другу',
          type: 'other',
          value: 5000,
          monthlyPayment: 500,
        }),
        create<BusinessCreditLiability>({
          id: 'business_credit1',
          value: 40000,
          name: 'Кредит за ларек',
          type: 'business_credit',
          monthlyPayment: 5000,
        }),
      ],
    };

    const possessionStateTransformer = new PossessionStateTransformer();
    const newPossessionState = possessionStateTransformer.generatePossessionState(
      initialPossesssions
    );

    const expectedPossessionState: PossessionState = {
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
        {
          id: 'debenture1',
          name: 'Облигации',
          type: 'investment',
          value: 320,
        },
      ],
      expenses: [
        {
          id: 'expense1',
          name: 'Общее',
          value: 20000,
        },
      ],
      assets: [
        create<InsuranceAsset>({
          id: 'insurance1',
          name: 'Страховка квартиры',
          type: 'insurance',
          value: 50000,
          cost: 5000,
          duration: 12,
          fromMonth: 1,
          insuranceType: 'health',
        }),
        create<DebentureAsset>({
          id: 'debenture1',
          name: 'ОФЗ',
          type: 'debenture',
          count: 4,
          averagePrice: 1100,
          profitabilityPercent: 8,
          nominal: 1000,
        }),
        create<StockAsset>({
          id: 'stocks1',
          name: 'Яндекс',
          countInPortfolio: 1,
          type: 'stock',
          fairPrice: 100,
          averagePrice: 100,
        }),
        create<RealtyAsset>({
          id: 'realty1',
          name: 'Квартира',
          type: 'realty',
          cost: 2000000,
          downPayment: 1000000,
        }),
        create<BusinessAsset>({
          id: 'business1',
          name: 'Ларек с шавой',
          type: 'business',
          fairPrice: 200_000,
          downPayment: 100_000,
          buyPrice: 210_000,
          payback: 20,
          passiveIncomePerMonth: 2000,
          sellProbability: 5,
        }),
        create<OtherAsset>({
          id: 'other_asset1',
          name: 'Биткойны',
          type: 'other',
          value: 30000,
          downPayment: 30000,
        }),
        create<CashAsset>({
          id: 'cash1',
          type: 'cash',
          value: 500,
          name: 'Наличные',
        }),
      ],
      liabilities: [
        create<MortgageLiability>({
          id: 'mortgage1',
          name: 'Ипотека',
          type: 'mortgage',
          value: 2000000,
          monthlyPayment: 20000,
        }),
        create<OtherLiability>({
          id: 'other_libility1',
          name: 'Долг другу',
          type: 'other',
          value: 5000,
          monthlyPayment: 500,
        }),
        create<BusinessCreditLiability>({
          id: 'business_credit1',
          value: 40000,
          name: 'Кредит за ларек',
          type: 'business_credit',
          monthlyPayment: 5000,
        }),
      ],
    };

    expect(newPossessionState).toStrictEqual(expectedPossessionState);
  });
});
