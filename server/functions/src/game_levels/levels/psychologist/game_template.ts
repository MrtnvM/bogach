import { GameTemplate } from '../../../game_templates/models/game_template';

export const template: GameTemplate = {
  id: 'psychologist',
  name: 'Психолог',
  icon:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/quest_icons_images%2Fpsychologist.png?alt=media&token=d2722d79-e95f-41c8-a732-7179b6d27cdb',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2F%C2%A0psyhologist.jpg?alt=media&token=52068ed0-31c8-40f7-9a04-6332e5167148',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 55_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 28_000,
      },
      {
        id: 'expense2',
        name: 'Съемная квартира',
        value: 19_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 14_000,
    credit: 0,
    cashFlow: 8_000,
  },
  target: {
    type: 'cash',
    value: 100_000,
  },
};
