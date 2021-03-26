import { GameTemplate } from '../models/game_template';

export const blackBmwTemplate: GameTemplate = {
  id: 'black_bmw_template',
  name: 'Чёрный бумер',
  icon:
    'https://www.flaticon.com/svg/static/icons/svg/805/805871.svg',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Fbogach.jpg?alt=media&token=ce61cfd1-c710-4563-b88b-9e96c4851e45',
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
