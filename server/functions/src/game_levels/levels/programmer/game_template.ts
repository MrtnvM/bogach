import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'programmer',
  name: 'Программист',
  icon:
    'https://s1.iconbird.com/ico/2013/6/382/w256h2561372594116ManRed2.png',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 80_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 36_000,
      },
      {
        id: 'expense2',
        name: 'Съемная квартира',
        value: 30_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 20000,
    credit: 0,
    cashFlow: 14_000,
  },
  target: {
    type: 'cash',
    value: 180_000,
  },
};
