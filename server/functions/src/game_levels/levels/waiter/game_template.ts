import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'waiter',
  name: 'Официант',
  icon:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/quest_icons_images%2Fwaiter.png?alt=media&token=9d628ff1-7643-4072-8c34-e47be1ef3526',
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
