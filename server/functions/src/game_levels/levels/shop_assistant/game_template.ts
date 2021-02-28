import { GameTemplate } from '../../../game_templates/models/game_template';

export const template: GameTemplate = {
  id: 'shop_assistant',
  name: 'Продавец-консультант',
  icon:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/quest_icons_images%2Fshop_assistent.png?alt=media&token=ac85e1fc-fafd-4f55-8243-855f28d19725',
  image:
    'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/game_images%2Fseller.jpg?alt=media&token=695576e1-2342-47c3-9bfc-52fb92380468',
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
