import { GameTemplate } from '../models/game_template';

export const managerTemplate: GameTemplate = {
  id: 'manager_template',
  name: 'Независимый менеджер',
  icon: 'https://www.flaticon.com/svg/static/icons/svg/2674/2674984.svg',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Ftraider.jpeg?alt=media&token=1048f6cd-1364-435b-b6d7-6a267a8a5ef6',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 90_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 40_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 100_000,
    credit: 0,
    cashFlow: 50_000,
  },
  target: {
    type: 'passive_income',
    value: 30_000,
  },
};
