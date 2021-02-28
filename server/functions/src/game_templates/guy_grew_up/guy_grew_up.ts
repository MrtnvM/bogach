import { GameTemplate } from '../models/game_template';

export const guyGrewUpTemplate: GameTemplate = {
  id: 'guy_grew_up_template',
  name: 'Малый повзрослел',
  icon:
    'https://www.flaticon.com/svg/static/icons/svg/385/385350.svg',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Fmillionaire.jpg?alt=media&token=a76c9fcb-3caf-4378-a11c-1828151771d9',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 50_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 13_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 150_000,
    credit: 0,
    cashFlow: 37_000,
  },
  target: {
    type: 'cash',
    value: 1_200_000,
  },
};
