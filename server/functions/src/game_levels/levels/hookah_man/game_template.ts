import { GameTemplate } from '../../../game_templates/models/game_template';

export const template: GameTemplate = {
  id: 'hookah_man',
  name: 'Кальянщик',
  icon:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/quest_icons_images%2Fhookah_man.png?alt=media&token=a6979ee8-1bb0-4be3-908a-558dea33f18d',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Fhookah_man.jpg?alt=media&token=daa74561-504a-4b93-8755-097001846175',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 40000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 20000,
      },
      {
        id: 'expense2',
        name: 'Съемная квартира',
        value: 15000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 10000,
    credit: 0,
    cashFlow: 5000,
  },
  target: {
    type: 'cash',
    value: 30000,
  },
};
