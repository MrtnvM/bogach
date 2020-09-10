import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'programmer',
  name: 'Программист',
  icon:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/quest_icons_images%2Fprogrammer.png?alt=media&token=5adae820-e84d-4cc4-af7f-86533f893c1f',
  possessions: {
    incomes: [
      {
        id: 'income1',
        name: 'Зарплата',
        value: 80_000,
        type: 'salary',
      },
    ],
    expenses: [
      {
        id: 'expense1',
        name: 'Общее',
        value: 36_000,
      },
      {
        id: 'expense2',
        name: 'Съемная квартира',
        value: 30_000,
      },
    ],
    assets: [],
    liabilities: [],
  },
  accountState: {
    cash: 20000,
    credit: 0,
    cashFlow: 14_000,
  },
  target: {
    type: 'cash',
    value: 180_000,
  },
};
