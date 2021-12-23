import { GameTemplate } from '../models/game_template';

export const firstStepsTemplate: GameTemplate = {
  id: 'first_steps_template',
  name: 'Первые шаги',
  icon: 'https://www.flaticon.com/svg/static/icons/svg/1056/1056227.svg',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Fbeginner.jpg?alt=media&token=05d1d4d0-df0e-4dfc-b365-9de1dc947c1a',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 40_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 10_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 2_000,
    credit: 0,
    cashFlow: 30_000,
  },
  target: {
    type: 'cash',
    value: 450_000,
  },
};
