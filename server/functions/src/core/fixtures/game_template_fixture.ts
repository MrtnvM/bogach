import { GameTemplate } from '../../game_templates/models/game_template';
import { Possessions } from '../../models/domain/possessions';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { StockAsset } from '../../models/domain/assets/stock_asset';
import { RealtyAsset } from '../../models/domain/assets/realty_asset';
import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { OtherAsset } from '../../models/domain/assets/other_asset';
import { CashAsset } from '../../models/domain/assets/cash_asset';
import { MortgageLiability } from '../../models/domain/liabilities/mortgage_liability';
import { OtherLiability } from '../../models/domain/liabilities/other_liability';
import { BusinessCreditLiability } from '../../models/domain/liabilities/business_credit';

export namespace GameTemplateFixture {
  const create = <T>(obj: T) => obj;

  export const createGameTemplate = (
    template: Partial<GameTemplate> | undefined = undefined
  ): GameTemplate => {
    const initialPossessions: Possessions = {
      incomes: [
        {
          id: 'income1',
          value: 92_000,
          name: 'Зарплата',
          type: 'salary',
        },
        {
          id: 'income2',
          value: 1_000,
          name: 'Карманные от бабушки',
          type: 'other',
        },
      ],
      expenses: [
        {
          id: 'expense1',
          name: 'Общее',
          value: 20_000,
        },
      ],
      assets: [
        create<InsuranceAsset>({
          id: 'insurance1',
          name: 'Страховка квартиры',
          type: 'insurance',
          value: 50_000,
          cost: 5_000,
          duration: 12,
          fromMonth: 1,
          insuranceType: 'health',
        }),
        create<DebentureAsset>({
          id: 'debenture1',
          name: 'ОФЗ',
          type: 'debenture',
          count: 4,
          averagePrice: 1_100,
          profitabilityPercent: 8,
          nominal: 1_000,
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
          buyPrice: 2_000_000,
          fairPrice: 2_005_000,
          payback: 20,
          sellProbability: 8,
          downPayment: 100_000,
          passiveIncomePerMonth: 14_000,
        }),
        create<BusinessAsset>({
          id: 'business1',
          name: 'Ларек с шавой',
          type: 'business',
          fairPrice: 200_000,
          downPayment: 100_000,
          buyPrice: 210_000,
          payback: 20,
          passiveIncomePerMonth: 2_000,
          sellProbability: 5,
        }),
        create<OtherAsset>({
          id: 'other_asset1',
          name: 'Биткойны',
          type: 'other',
          value: 30_000,
          downPayment: 30_000,
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
          value: 2_000_000,
          monthlyPayment: 20_000,
        }),
        create<OtherLiability>({
          id: 'other_libility1',
          name: 'Долг другу',
          type: 'other',
          value: 5_000,
          monthlyPayment: 500,
        }),
        create<BusinessCreditLiability>({
          id: 'business_credit1',
          value: 40_000,
          name: 'Кредит за ларек',
          type: 'business_credit',
          monthlyPayment: 5_000,
        }),
      ],
    };

    const gameTemplate: GameTemplate = {
      id: template?.id || 'template1',
      name: template?.name || 'Game 1',
      icon: 'https://image.flaticon.com/icons/png/128/1907/1907938.png',
      image: 'https://image.flaticon.com/icons/png/128/1907/1907938.png',
      possessions: template?.possessions || initialPossessions,
      accountState: template?.accountState || {
        cashFlow: 10_000,
        cash: 20_000,
        credit: 0,
      },
      target: template?.target || { type: 'cash', value: 1_000_000 },
    };

    return gameTemplate;
  };
}
