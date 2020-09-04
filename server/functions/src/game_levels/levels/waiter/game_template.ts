import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'waiter',
  name: 'Официант',
  icon:
    'https://www.shareicon.net/data/256x256/2016/08/04/806819_man_512x512.png',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 45000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 21000,
      },
      {
        id: 'expense2',
        name: 'Съёмная квартира',
        value: 17000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 11000,
    credit: 0,
    cashFlow: 7000,
  },
  target: {
    type: 'cash',
    value: 65000,
  },
};
