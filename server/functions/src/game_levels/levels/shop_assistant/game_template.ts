import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'shop_assistant',
  name: 'Продавец-консультант',
  icon: 'https://image.flaticon.com/icons/png/128/3361/3361382.png',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 49000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 22000,
      },
      {
        id: 'expense2',
        name: 'Съёмная квартира',
        value: 19000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 12000,
    credit: 0,
    cashFlow: 8000,
  },
  target: {
    type: 'cash',
    value: 75000,
  },
};
