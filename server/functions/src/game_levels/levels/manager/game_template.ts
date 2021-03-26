import { GameTemplate } from '../../../game_templates/models/game_template';

export const template: GameTemplate = {
  id: 'manager',
  name: 'Менеджер',
  icon:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/quest_icons_images%2Fmanager.png?alt=media&token=7320129b-cb27-4197-9270-8a4cc7f39d9e',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Fmanager.jpg?alt=media&token=59ed2818-c357-4fa7-a90f-94434434bb2d',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 100_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 42_000,
      },
      {
        id: 'expense2',
        name: 'Съемная квартира',
        value: 40_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 27_000,
    credit: 0,
    cashFlow: 18_000,
  },
  target: {
    type: 'cash',
    value: 280_000,
  },
};
