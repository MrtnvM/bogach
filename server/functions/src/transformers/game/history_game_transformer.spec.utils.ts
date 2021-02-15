/// <reference types="@types/jest"/>

import { GameEntity } from '../../models/domain/game/game';
import { IncomeGenerateRule } from '../../generators/rules/income_generate_rule';
import { IncomeGeneratorConfig } from '../../events/income/income_generator_config';
import { ExpenseGenerateRule } from '../../generators/rules/expense_generate_rule';
import { ExpenseGeneratorConfig } from '../../events/expense/expense_generator_config';
import { InsuranceGenerateRule } from '../../generators/rules/insurance_generate_rule';
import { InsuranceGeneratorConfig } from '../../events/insurance/insurance_generator_config';
import { DebentureGenerateRule } from '../../generators/rules/debenture_generate_rule';
import { MonthlyExpenseGenerateRule } from '../../generators/rules/monthly_expense_generate_rule';
import { StockGenerateRule } from '../../generators/rules/stock_generate_rule';
import { RealEstateBuyRule } from '../../generators/rules/real_estate_buy_generate_rule';
import { BusinessBuyGenerateRule } from '../../generators/rules/business_buy_generate_rule';
import { BusinessSellGenerateRule } from '../../generators/rules/business_sell_generate_rules';
import { Rule } from '../../generators/generator_rule';

const incomeRule = new IncomeGenerateRule(
  {
    probabilityLevel: 4,
    minDistanceBetweenEvents: 3,
    maxHistoryLength: 1,
    maxCountOfEventInMonth: 1,
  },
  IncomeGeneratorConfig.allIncomes
);

const expenseRule = new ExpenseGenerateRule(
  {
    probabilityLevel: 4,
    minDistanceBetweenEvents: 2,
    maxHistoryLength: 6,
    maxCountOfEventInMonth: 1,
  },
  ExpenseGeneratorConfig.allExpenses
);

const healthInsuranceRule = new InsuranceGenerateRule(
  {
    probabilityLevel: 5,
    minDistanceBetweenEvents: 6,
    maxHistoryLength: 4,
    maxCountOfEventInMonth: 1,
  },
  InsuranceGeneratorConfig.healthInsurance()
);

const propertyInsuranceRule = new InsuranceGenerateRule(
  {
    probabilityLevel: 5,
    minDistanceBetweenEvents: 6,
    maxHistoryLength: 4,
    maxCountOfEventInMonth: 1,
  },
  InsuranceGeneratorConfig.propertyInsurance()
);

const debentureRule = new DebentureGenerateRule({
  probabilityLevel: 10,
  minDistanceBetweenEvents: 0,
  maxHistoryLength: -1,
  maxCountOfEventInMonth: 1,
});

const monthlyExpenseRule = new MonthlyExpenseGenerateRule({
  probabilityLevel: 3,
  minDistanceBetweenEvents: 2,
  maxHistoryLength: 12,
  maxCountOfEventInMonth: 1,
});

const stockRule = new StockGenerateRule({
  probabilityLevel: 10,
  minDistanceBetweenEvents: 0,
  maxHistoryLength: -4,
  maxCountOfEventInMonth: 3,
});

const realEstateRule = new RealEstateBuyRule({
  probabilityLevel: 10,
  minDistanceBetweenEvents: 1,
  maxHistoryLength: 4,
  maxCountOfEventInMonth: 1,
});

const businessBuyGenerateRule = new BusinessBuyGenerateRule({
  probabilityLevel: 6,
  minDistanceBetweenEvents: 2,
  maxHistoryLength: 6,
  maxCountOfEventInMonth: 1,
});

const businessSellGenerateRule = new BusinessSellGenerateRule({
  probabilityLevel: 4,
  minDistanceBetweenEvents: 10,
  maxHistoryLength: 12,
  maxCountOfEventInMonth: 1,
});

export const rules: Rule[] = [
  incomeRule,
  expenseRule,
  healthInsuranceRule,
  propertyInsuranceRule,
  debentureRule,
  monthlyExpenseRule,
  stockRule,
  realEstateRule,
  businessBuyGenerateRule,
  businessSellGenerateRule,
];

export const history: GameEntity.History = {
  months: [
    // Month 1
    {
      events: [
        {
          data: {
            businessId: '19f46fca-881d-4375-b8b5-f36a20b6abb2',
            currentPrice: 87000,
            debt: 74000,
            downPayment: 13000,
            fairPrice: 70000,
            passiveIncomePerMonth: 4500,
            payback: 62,
            sellProbability: 4,
          },
          description: 'Автомойка',
          id: 'd3043ee4-8af0-405b-98b9-66aca6e2ae66',
          name: 'Автомойка',
          type: 'business-buy-event',
        },
        {
          data: {
            availableCount: 100,
            currentPrice: 27.109523395409138,
            fairPrice: 29.292500000000004,
          },
          description: '',
          id: '44347aba-41a9-4740-ac62-3724676fca18',
          name: 'Сургутнефтегаз',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 3951.9204966136836,
            fairPrice: 4347.2,
          },
          description: '',
          id: '03299e1a-d287-43ff-94c3-eca25fa82ab2',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
        {
          data: { expense: 3000, insuranceType: 'property' },
          description: 'Срочно нужны деньги на ремонт компьютера',
          id: '2513c09b-3e4b-4377-972c-0c1e08c24fc6',
          name: 'Проблемы с имуществом',
          type: 'expense-event',
        },
        {
          data: { expenseName: 'Ребёнок', monthlyPayment: 5000 },
          description: 'В вашей семье пополнение',
          id: '23f2f75f-f400-4273-948c-3f16b76e5259',
          name: 'Поздравляем с рождением ребёнка!',
          type: 'monthly-expense-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 1300,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1300 ₽',
          id: 'e7106bd0-5f89-44bd-a424-c5818c97f773',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 107.48312550223284,
            fairPrice: 117.57999999999998,
          },
          description: '',
          id: '086ad70e-7fa8-4d3a-8098-688070912ed9',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 2
    {
      events: [
        {
          data: {
            availableCount: 160,
            currentPrice: 1298,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1298 ₽',
          id: '3c99feda-48d3-4f46-b662-398de82e0b4f',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            assetName: '1-комн. Квартира',
            currentPrice: 1200000,
            debt: 992000,
            downPayment: 208000,
            fairPrice: 1030000,
            passiveIncomePerMonth: -7400,
            payback: -7,
            realEstateId: '4aace56e-9b23-4d33-8d78-0a224cfe1d89',
            sellProbability: 17,
          },
          description: '',
          id: 'f60089ae-dd3c-4567-b3d2-7956779f431d',
          name: 'Продаётся квартира',
          type: 'real-estate-buy-event',
        },
        {
          data: { cost: 2000, duration: 12, insuranceType: 'health', value: 5500 },
          description:
            'Страховая компания предлагает купить полис и защитить свое здоровье от непредвиденных ситуаций',
          id: '166b737d-9fbb-42f9-9b28-0bee846a7291',
          name: 'Страхование здоровья',
          type: 'insurance-event',
        },
        {
          data: { income: 10000 },
          description: 'Вы получили единоразовую социальную выплату',
          id: '7848fc6a-a97f-46cd-83d7-227f9c201330',
          name: 'Программа государственной поддержки',
          type: 'income-event',
        },
        {
          data: {
            availableCount: 90,
            currentPrice: 153.7396445557502,
            fairPrice: 119.93416666666667,
          },
          description: '',
          id: '87e9291f-3c57-4343-8f12-edb8f4d55c06',
          name: 'Сбербанк России - привилегированные акции',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 309.4692952029121,
            fairPrice: 340.5375,
          },
          description: '',
          id: 'c3e999e7-101f-4ac2-a60e-b5ed38d5f663',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 100,
            currentPrice: 105.45487749744512,
            fairPrice: 117.57999999999998,
          },
          description: '',
          id: 'c0c19af1-527c-4e4d-8a30-d09416fb9c83',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 3
    {
      events: [
        {
          data: {
            availableCount: 170,
            currentPrice: 1286.08,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1286.08 ₽',
          id: 'f6bff047-1b4a-4a5f-9a04-0e4c770089b1',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 3004.048354247211,
            fairPrice: 3035.2916666666665,
          },
          description: '',
          id: '643abd20-eba9-420f-8c0d-d9fb05cdae85',
          name: 'ЛУКОЙЛ',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 313.8517207255435,
            fairPrice: 337.14583333333337,
          },
          description: '',
          id: '89421800-b11f-4977-91ef-d6b24917005c',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 29.498787556902773,
            fairPrice: 28.94333333333333,
          },
          description: '',
          id: 'ac082ddc-acef-46fb-85ed-460c3d5f11c5',
          name: 'Сургутнефтегаз',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 4
    {
      events: [
        {
          data: {
            businessId: '0ccc9559-f90b-42c9-a133-db07fda36731',
            currentPrice: 145000,
            debt: 123000,
            downPayment: 22000,
            fairPrice: 127000,
            passiveIncomePerMonth: 4000,
            payback: 33,
            sellProbability: 3,
          },
          description: 'Магазин продуктов',
          id: 'f699f5e4-e73c-4964-b9ab-0eb26297df89',
          name: 'Магазин продуктов',
          type: 'business-buy-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 163.6370574571419,
            fairPrice: 128.75833333333333,
          },
          description: '',
          id: '399a72a6-d128-4272-8dc8-680a4851aea7',
          name: 'Сбербанк России - привилегированные акции',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 140,
            currentPrice: 4721.8735199773855,
            fairPrice: 4351.404166666667,
          },
          description: '',
          id: '526fafbf-113f-43c3-9e02-a86545dcec04',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 1294.6368,
            nominal: 1000,
            profitabilityPercent: 8.3,
          },
          description: 'Текущая цена: 1294.6368 ₽',
          id: 'c7cfa0af-e6a2-4f94-b729-6ac10801447b',
          name: 'Томская область',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 140,
            currentPrice: 3124.5134665380733,
            fairPrice: 3034.9583333333335,
          },
          description: '',
          id: 'bdff4bbd-d96d-4f50-8e81-686ea0300df0',
          name: 'ЛУКОЙЛ',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 5
    {
      events: [
        {
          data: {
            availableCount: 120,
            currentPrice: 187.5090594158131,
            fairPrice: 132.66916666666665,
          },
          description: '',
          id: '23f99e98-fa09-43f6-a15b-b2abd50c4da6',
          name: 'Сбербанк России - привилегированные акции',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 1252.851328,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1252.851328 ₽',
          id: '3e0beb61-3532-4ac7-8a43-fc2d6243394d',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 100,
            currentPrice: 3255.0378259053427,
            fairPrice: 3034.625,
          },
          description: '',
          id: 'a6e6e13e-444c-49e2-be1e-14816fb8d257',
          name: 'ЛУКОЙЛ',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 140,
            currentPrice: 4803.4888468057725,
            fairPrice: 4390.659166666667,
          },
          description: '',
          id: 'dca99b95-2d99-4131-8de9-4426996697a8',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 6
    {
      events: [
        {
          data: { income: 9000 },
          description: 'Вы получили премию на работе',
          id: '2abcd1cd-ed8c-4729-8be9-c55af8d80e96',
          name: 'Премия',
          type: 'income-event',
        },
        {
          data: {
            availableCount: 90,
            currentPrice: 292.33907417603035,
            fairPrice: 328.8625,
          },
          description: '',
          id: '9a07d2d4-9740-4381-ae64-cc1cccd236ec',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 150,
            currentPrice: 1262.7372748799999,
            nominal: 1000,
            profitabilityPercent: 6.3,
          },
          description: 'Текущая цена: 1262.7372748799999 ₽',
          id: '5edb1cf9-2098-4db6-84d7-877f2c682ac2',
          name: 'Республика Якутия',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 4751.058382720204,
            fairPrice: 4450.4025,
          },
          description: '',
          id: '6f228778-7b66-4ef0-a08e-78cbfedcba9e',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 198.83067208351832,
            fairPrice: 138.37333333333333,
          },
          description: '',
          id: 'f25df22b-45ff-44a6-aaa3-66fc46e7d806',
          name: 'Сбербанк России - привилегированные акции',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 7
    {
      events: [
        {
          data: {
            businessId: '5b25ddbf-ae50-47ad-8a03-cf76966488c7',
            currentPrice: 93000,
            debt: 82000,
            downPayment: 11000,
            fairPrice: 126000,
            passiveIncomePerMonth: 4000,
            payback: 52,
            sellProbability: 12,
          },
          description: 'Магазин продуктов',
          id: 'f353a411-a521-4ebe-8f92-0d8efc507970',
          name: 'Магазин продуктов',
          type: 'business-buy-event',
        },
        {
          data: {
            availableCount: 190,
            currentPrice: 1272.2277838848,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1272.2277838848 ₽',
          id: 'c4931f81-be21-4905-91db-403d3160d8f9',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 100,
            currentPrice: 30.577983374855435,
            fairPrice: 28.561666666666667,
          },
          description: '',
          id: '4a0cabac-58de-4be9-b074-d818485c02ce',
          name: 'Сургутнефтегаз',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 3499.47109460273,
            fairPrice: 3033.7916666666665,
          },
          description: '',
          id: 'e1bf4d2f-7a8a-4836-ab6b-32c25313682a',
          name: 'ЛУКОЙЛ',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 115.15624647245804,
            fairPrice: 114.06416666666667,
          },
          description: '',
          id: '6d0feeb7-f6a6-43bc-acf9-f0cb0204bf39',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 8
    {
      events: [
        {
          data: {
            availableCount: 110,
            currentPrice: 111.84069475762489,
            fairPrice: 112.46416666666666,
          },
          description: '',
          id: '18a51433-71e4-435b-b4f1-0670fbb23b36',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 1271.3386725294079,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1271.3386725294079 ₽',
          id: 'c6a93bd1-2a14-4799-a972-50dedeb82f21',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 322.8077616957979,
            fairPrice: 314.8041666666666,
          },
          description: '',
          id: '58e1c888-f6c3-4e2f-b157-5bcd9aee40d6',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 221.31463580989524,
            fairPrice: 150.71833333333333,
          },
          description: '',
          id: '3c5d8dc0-550e-459b-854b-aeecb67e79f1',
          name: 'Сбербанк России - привилегированные акции',
          type: 'stock-price-changed-event',
        },
        {
          data: { expense: 4000, insuranceType: 'property' },
          description: 'Срочно нужны деньги на ремонт холодильника',
          id: 'c8ad644c-77c7-4d8b-b7cb-9cdabb294a21',
          name: 'Проблемы с имуществом',
          type: 'expense-event',
        },
      ],
    },
    // Month 9
    {
      events: [
        {
          data: {
            availableCount: 90,
            currentPrice: 1270.4851256282316,
            nominal: 1000,
            profitabilityPercent: 8.3,
          },
          description: 'Текущая цена: 1270.4851256282316 ₽',
          id: 'bf040050-a056-4fac-9800-7f9a5341ba71',
          name: 'Томская область',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            assetName: 'Гараж',
            currentPrice: 137000,
            debt: 118800,
            downPayment: 18200,
            fairPrice: 143000,
            passiveIncomePerMonth: 400,
            payback: 4,
            realEstateId: 'fff2a53c-d343-42cb-8eeb-39d1da454773',
            sellProbability: 17,
          },
          description: '',
          id: '3b13c485-ae7e-4a2e-bc31-896f5a099ff5',
          name: 'Продаётся гараж',
          type: 'real-estate-buy-event',
        },
        {
          data: { cost: 4500, duration: 12, insuranceType: 'property', value: 8500 },
          description:
            'Страховая компания предлагает купить полис и защитить свое имущество от непредвиденных ситуаций',
          id: '6a12870d-ef73-48fa-a9c7-013e48dc6ff9',
          name: 'Страхование имущества',
          type: 'insurance-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 323.5375281399895,
            fairPrice: 314.7541666666666,
          },
          description: '',
          id: '7135f961-ab2e-4bc4-a195-19a32ff8f77d',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 29.21204868065494,
            fairPrice: 28.204166666666666,
          },
          description: '',
          id: '62772bf6-6ed5-4ded-a478-f5e49e224b31',
          name: 'Сургутнефтегаз',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 100,
            currentPrice: 4663.205173168348,
            fairPrice: 4474.735833333333,
          },
          description: '',
          id: '5a74ec1c-34a0-4ede-8a37-c12d4aa4f06b',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 10
    {
      events: [
        {
          data: { income: 20000 },
          description: 'Вы получили налоговый вычет',
          id: '73f584a4-43e3-4615-9071-fb1d6044b8e4',
          name: 'Налоговый вычет',
          type: 'income-event',
        },
        {
          data: {
            availableCount: 160,
            currentPrice: 1229.6657206031023,
            nominal: 1000,
            profitabilityPercent: 8.3,
          },
          description: 'Текущая цена: 1229.6657206031023 ₽',
          id: 'f6400c73-33ba-461a-881d-5f9c99e37fe4',
          name: 'Томская область',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 140,
            currentPrice: 108.5713410547687,
            fairPrice: 111.97416666666665,
          },
          description: '',
          id: '714c9bd0-fccf-4fca-91aa-5483052b3fda',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            businessId: 'c72475a6-291a-4a3d-b32e-8497432b83ec',
            currentPrice: 73000,
            debt: 48000,
            downPayment: 25000,
            fairPrice: 117000,
            passiveIncomePerMonth: 3000,
            payback: 49,
            sellProbability: 13,
          },
          description: 'Грузоперевозки',
          id: 'aad91050-283d-40d3-9799-c4036e08b21b',
          name: 'Грузоперевозки',
          type: 'business-buy-event',
        },
        {
          data: {
            availableCount: 90,
            currentPrice: 4129.022361464591,
            fairPrice: 3204.6666666666665,
          },
          description: '',
          id: '5d770336-1ab1-4609-9bb2-f8c89107e60f',
          name: 'ЛУКОЙЛ',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 29.159364866369607,
            fairPrice: 28.126666666666665,
          },
          description: '',
          id: '4846809c-ed0d-4317-aa39-d9f501f4cc42',
          name: 'Сургутнефтегаз',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 11
    {
      events: [
        {
          data: {
            availableCount: 140,
            currentPrice: 3781.2946230026505,
            fairPrice: 4443.9025,
          },
          description: '',
          id: 'a5820b65-75ee-42de-84cb-444c6ab5e562',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 4090.2813574817174,
            fairPrice: 3322.3333333333335,
          },
          description: '',
          id: 'f18d14f2-30b2-4854-a829-48186d970520',
          name: 'ЛУКОЙЛ',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 140,
            currentPrice: 112.97723506917548,
            fairPrice: 112.45333333333332,
          },
          description: '',
          id: '50d26b18-8867-4522-afdc-1344f4c78e55',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 190,
            currentPrice: 1210.4790917789783,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1210.4790917789783 ₽',
          id: 'b61044d1-87ef-4b8b-a6a3-64819a64244d',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
      ],
    },
    // Month 12
    {
      events: [
        {
          data: {
            availableCount: 140,
            currentPrice: 4201.012198654665,
            fairPrice: 4389.735833333333,
          },
          description: '',
          id: 'dcb528df-7268-49dc-a8e2-74f05a53fb3d',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 90,
            currentPrice: 1162.0599281078191,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1162.0599281078191 ₽',
          id: '156c513c-87da-4c93-830d-f2e623574910',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 90,
            currentPrice: 396.99625085084665,
            fairPrice: 326.59166666666664,
          },
          description: '',
          id: '1083bd6c-a2f3-4ac3-8735-9d9382b84239',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 28.834861239411154,
            fairPrice: 28.16291666666667,
          },
          description: '',
          id: '9f8eed58-e9f9-4025-93cf-c4c5a601b551',
          name: 'Сургутнефтегаз',
          type: 'stock-price-changed-event',
        },
      ],
    },
    // Month 13
    {
      events: [
        {
          data: {
            businessId: '81f6796d-a409-4e8b-a716-83aea3957811',
            currentPrice: 126000,
            debt: 113000,
            downPayment: 13000,
            fairPrice: 116000,
            passiveIncomePerMonth: 1000,
            payback: 10,
            sellProbability: 11,
          },
          description: 'Кафе',
          id: 'f5ba6b80-3beb-4b96-b9f2-8dc5fd680c44',
          name: 'Кафе',
          type: 'business-buy-event',
        },
        {
          data: {
            availableCount: 90,
            currentPrice: 411.34343242861996,
            fairPrice: 332.68749999999994,
          },
          description: '',
          id: '6eb68ed0-0d18-4114-8fb1-1467ee5efe04',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 200,
            currentPrice: 1165.5775309835064,
            nominal: 1000,
            profitabilityPercent: 8.3,
          },
          description: 'Текущая цена: 1165.5775309835064 ₽',
          id: '1dd4e632-3075-419d-820a-1adbbddbd0c9',
          name: 'Томская область',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 110,
            currentPrice: 4348.735650103926,
            fairPrice: 3569.625,
          },
          description: '',
          id: '77b56f8f-7670-45f7-a5c7-55bf1e9c341f',
          name: 'ЛУКОЙЛ',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 176.80917250193338,
            fairPrice: 184.88416666666663,
          },
          description: '',
          id: '70a5930e-859d-4bd0-86d2-2b62a29a54dc',
          name: 'Сбербанк России - привилегированные акции',
          type: 'stock-price-changed-event',
        },
        {
          data: { income: 7500 },
          description: 'Вы продали неиспользуемый письменный стол на Авито',
          id: '632feb5a-8e87-4105-a70d-c924c4f00f94',
          name: 'Продажа',
          type: 'income-event',
        },
      ],
    },
    // Month 14
    {
      events: [
        {
          data: {
            availableCount: 130,
            currentPrice: 159.56420994662142,
            fairPrice: 188.83666666666667,
          },
          description: '',
          id: 'be097d54-73cd-4148-a488-305293d65682',
          name: 'Сбербанк России - привилегированные акции',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 4116.883541917196,
            fairPrice: 4455.916666666667,
          },
          description: '',
          id: '89586e4a-f2bf-4762-9df0-6616481c82a5',
          name: 'Полюс Золото',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 90,
            currentPrice: 1118.9544297441662,
            nominal: 1000,
            profitabilityPercent: 6.3,
          },
          description: 'Текущая цена: 1118.9544297441662 ₽',
          id: '6658c9e2-448a-4aed-99d0-d1a86bf7ddbd',
          name: 'Республика Якутия',
          type: 'debenture-price-changed-event',
        },
        {
          data: { income: 7500 },
          description: 'Вы продали неиспользуемый письменный стол на Авито',
          id: '632feb5a-8e87-4105-a70d-c924c4f00f94',
          name: 'Продажа',
          type: 'income-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 103.35568183758241,
            fairPrice: 113.38499999999999,
          },
          description: '',
          id: '7f5cb8e8-09ed-4163-83b3-0c9e58224ca8',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
        {
          data: { expense: 2000, insuranceType: 'property' },
          description: 'Срочно нужны деньги на ремонт компьютера',
          id: '0773ebe1-8d47-4d69-9728-75ad63620c8d',
          name: 'Проблемы с имуществом',
          type: 'expense-event',
        },
      ],
    },
    // Month 15
    {
      events: [
        {
          data: {
            availableCount: 90,
            currentPrice: 1094.1962525543995,
            nominal: 1000,
            profitabilityPercent: 7.3,
          },
          description: 'Текущая цена: 1094.1962525543995 ₽',
          id: '6d284bd5-e697-4bd8-8cf6-30532b452a37',
          name: 'ОФЗ 29006',
          type: 'debenture-price-changed-event',
        },
        {
          data: {
            availableCount: 130,
            currentPrice: 28.363265511134095,
            fairPrice: 28.73958333333334,
          },
          description: '',
          id: 'aa3796b4-5506-43ca-85df-2971d28b0ef3',
          name: 'Сургутнефтегаз',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 120,
            currentPrice: 100.56864782019176,
            fairPrice: 112.77249999999998,
          },
          description: '',
          id: 'f63909f4-37ef-44a4-be95-2281b242a715',
          name: 'Московская Биржа',
          type: 'stock-price-changed-event',
        },
        {
          data: {
            availableCount: 140,
            currentPrice: 494.35033839697945,
            fairPrice: 352.6375,
          },
          description: '',
          id: 'c4318a95-781d-45e2-acf7-df37cb36baa4',
          name: 'Роснефть',
          type: 'stock-price-changed-event',
        },
      ],
    },
  ],
};

const month1: GameEntity.HistoryMonth = {
  events: [
    {
      data: { expenseName: 'Ребёнок', monthlyPayment: 5000 },
      description: 'В вашей семье пополнение',
      id: '23f2f75f-f400-4273-948c-3f16b76e5259',
      name: 'Поздравляем с рождением ребёнка!',
      type: 'monthly-expense-event',
    },
  ],
};

const month2: GameEntity.HistoryMonth = {
  events: [],
};

const month3: GameEntity.HistoryMonth = {
  events: [],
};
const month4: GameEntity.HistoryMonth = {
  events: [],
};
const month5: GameEntity.HistoryMonth = {
  events: [],
};
const month6: GameEntity.HistoryMonth = {
  events: [],
};
const month7: GameEntity.HistoryMonth = {
  events: [],
};
const month8: GameEntity.HistoryMonth = {
  events: [],
};
const month9: GameEntity.HistoryMonth = {
  events: [
    {
      data: {
        assetName: 'Гараж',
        currentPrice: 137000,
        debt: 118800,
        downPayment: 18200,
        fairPrice: 143000,
        passiveIncomePerMonth: 400,
        payback: 4,
        realEstateId: 'fff2a53c-d343-42cb-8eeb-39d1da454773',
        sellProbability: 17,
      },
      description: '',
      id: '3b13c485-ae7e-4a2e-bc31-896f5a099ff5',
      name: 'Продаётся гараж',
      type: 'real-estate-buy-event',
    },
    {
      data: { cost: 4500, duration: 12, insuranceType: 'property', value: 8500 },
      description:
        'Страховая компания предлагает купить полис и защитить свое имущество от непредвиденных ситуаций',
      id: '6a12870d-ef73-48fa-a9c7-013e48dc6ff9',
      name: 'Страхование имущества',
      type: 'insurance-event',
    },
  ],
};
const month10: GameEntity.HistoryMonth = {
  events: [
    {
      data: {
        businessId: 'c72475a6-291a-4a3d-b32e-8497432b83ec',
        currentPrice: 73000,
        debt: 48000,
        downPayment: 25000,
        fairPrice: 117000,
        passiveIncomePerMonth: 3000,
        payback: 49,
        sellProbability: 13,
      },
      description: 'Грузоперевозки',
      id: 'aad91050-283d-40d3-9799-c4036e08b21b',
      name: 'Грузоперевозки',
      type: 'business-buy-event',
    },
  ],
};
const month11: GameEntity.HistoryMonth = {
  events: [],
};
const month12: GameEntity.HistoryMonth = {
  events: [],
};
const month13: GameEntity.HistoryMonth = {
  events: [
    {
      data: {
        businessId: '81f6796d-a409-4e8b-a716-83aea3957811',
        currentPrice: 126000,
        debt: 113000,
        downPayment: 13000,
        fairPrice: 116000,
        passiveIncomePerMonth: 1000,
        payback: 10,
        sellProbability: 11,
      },
      description: 'Кафе',
      id: 'f5ba6b80-3beb-4b96-b9f2-8dc5fd680c44',
      name: 'Кафе',
      type: 'business-buy-event',
    },
  ],
};
const month14: GameEntity.HistoryMonth = {
  events: [
    {
      data: { income: 7500 },
      description: 'Вы продали неиспользуемый письменный стол на Авито',
      id: '632feb5a-8e87-4105-a70d-c924c4f00f94',
      name: 'Продажа',
      type: 'income-event',
    },
    {
      data: {
        availableCount: 120,
        currentPrice: 103.35568183758241,
        fairPrice: 113.38499999999999,
      },
      description: '',
      id: '7f5cb8e8-09ed-4163-83b3-0c9e58224ca8',
      name: 'Московская Биржа',
      type: 'stock-price-changed-event',
    },
    {
      data: { expense: 2000, insuranceType: 'property' },
      description: 'Срочно нужны деньги на ремонт компьютера',
      id: '0773ebe1-8d47-4d69-9728-75ad63620c8d',
      name: 'Проблемы с имуществом',
      type: 'expense-event',
    },
  ],
};
const month15: GameEntity.HistoryMonth = {
  events: [
    {
      data: {
        availableCount: 90,
        currentPrice: 1094.1962525543995,
        nominal: 1000,
        profitabilityPercent: 7.3,
      },
      description: 'Текущая цена: 1094.1962525543995 ₽',
      id: '6d284bd5-e697-4bd8-8cf6-30532b452a37',
      name: 'ОФЗ 29006',
      type: 'debenture-price-changed-event',
    },
    {
      data: {
        availableCount: 130,
        currentPrice: 28.363265511134095,
        fairPrice: 28.73958333333334,
      },
      description: '',
      id: 'aa3796b4-5506-43ca-85df-2971d28b0ef3',
      name: 'Сургутнефтегаз',
      type: 'stock-price-changed-event',
    },
    {
      data: {
        availableCount: 120,
        currentPrice: 100.56864782019176,
        fairPrice: 112.77249999999998,
      },
      description: '',
      id: 'f63909f4-37ef-44a4-be95-2281b242a715',
      name: 'Московская Биржа',
      type: 'stock-price-changed-event',
    },
    {
      data: {
        availableCount: 140,
        currentPrice: 494.35033839697945,
        fairPrice: 352.6375,
      },
      description: '',
      id: 'c4318a95-781d-45e2-acf7-df37cb36baa4',
      name: 'Роснефть',
      type: 'stock-price-changed-event',
    },
  ],
};

export const expectedHistory: GameEntity.History = {
  months: [
    month1,
    month2,
    month3,
    month4,
    month5,
    month6,
    month7,
    month8,
    month9,
    month10,
    month11,
    month12,
    month13,
    month14,
    month15,
  ],
};
