import { GameTemplate } from '../models/game_template';

export const blackBmwTemplate: GameTemplate = {
  id: 'black_bmw_template',
  name: 'Чёрный бумер',
  icon:
    'https://cdn.iconscout.com/icon/free/png-256/bmw-5-202750.png',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 92_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 20_000,
      },
    ],
    assets: [],
    liabilities: [
      {
        id: 'liability1',
        monthlyPayment: 20_000,
        name: 'Ипотека',
        type: 'mortgage',
        value: 2_000_000,
      },
    ],
  },
  accountState: {
    cash: 50_000,
    credit: 0,
    cashFlow: 52_000,
  },
  target: {
    type: 'cash',
    value: 1_400_000,
  },
};
