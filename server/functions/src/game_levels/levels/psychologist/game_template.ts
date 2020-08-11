import { GameTemplate } from '../../../models/domain/game/game_template';

export const template: GameTemplate = {
  id: 'psychologist',
  name: 'Психолог',
  icon:
    'https://lh3.googleusercontent.com/proxy/4tC-y8E0c27Aqqnu_ELqzbf_bjeTt08QiTLinMLZiISvpoot-8ThrcaSxGlNwIHHpLrEHJeBc6dB_rOE-Q1UQYd_xFA1TtW08LO026pm2ueRKOkgOXCJBbdgKiej1ruaoL41m5uTuUQ473k1I_3CWH5BzTpnH7k',
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
