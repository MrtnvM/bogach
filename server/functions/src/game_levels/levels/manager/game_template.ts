import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'manager',
  name: 'Менеджер',
  icon:
    'https://kupimkartridj.ru/images/icons/manager.png',
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
