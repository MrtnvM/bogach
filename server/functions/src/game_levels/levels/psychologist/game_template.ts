import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'psychologist',
  name: 'Психолог',
  icon:
    'https://cdn1.vectorstock.com/i/thumb-large/59/10/psychologist-consultant-icon-vector-18105910.jpg',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 55000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 30000,
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
    cash: 14000,
    credit: 0,
    cashFlow: 6000,
  },
  target: {
    type: 'cash',
    value: 100_000,
  },
};
