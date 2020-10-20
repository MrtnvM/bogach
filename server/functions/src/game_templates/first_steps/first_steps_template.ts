import { GameTemplate } from '../models/game_template';

export const firstStepsTemplate: GameTemplate = {
  id: 'first_steps_template',
  name: 'Первые шаги',
  icon:
    'https://www.flaticon.com/svg/static/icons/svg/1056/1056227.svg',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 15_000,
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
    cashFlow: 5_000,
  },
  target: {
    type: 'cash',
    value: 45_000,
  },
};
