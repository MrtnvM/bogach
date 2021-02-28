import { GameTemplate } from '../models/game_template';

export const courierTemplate: GameTemplate = {
  id: 'courier_template',
  name: 'Курьер, который хочет свободы',
  icon:
    'https://www.flaticon.com/svg/static/icons/svg/869/869034.svg',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Fbusinessman.jpg?alt=media&token=0f5aa549-f119-46dd-abc9-bfc2670217c9',
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
        value: 11_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 5_000,
    credit: 0,
    cashFlow: 4_000,
  },
  target: {
    type: 'passive_income',
    value: 15_000,
  },
};
