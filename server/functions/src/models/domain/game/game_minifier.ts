import { Game } from './game';

export namespace GameMinifier {
  const keyMinifiers = {
    name: 'n',
    description: 'd',
    type: 't',
    state: 's',
    participantsIds: 'pIds',
    participants: 'p-s',
    target: 'tar',
    currentEvents: 'cE',
    history: 'h',
    config: 'c-g',
    createdAt: 'crA',
    updatedAt: 'upA',
    value: 'v',
    months: 'm-s',
    stocks: 's-s',
    debentures: 'd-s',
    initialCash: 'iC',
    gameStatus: 'gS',
    moveStartDateInUTC: 'mvUTC',
    monthNumber: 'mN',
    gameTemplateId: 'gTI',
    winners: 'w-s',
    progress: 'pr',
    possessions: 'po-s',
    possessionState: 'pS',
    account: 'a',
    currentEventIndex: 'cEI',
    currentMonthForParticipant: 'cMFP',
    status: 'st',
    monthResults: 'mR',
    cash: 'c-h',
    totalIncome: 'tI',
    totalExpense: 'tE',
    totalAssets: 'tA',
    totalLiabilities: 'tL',
    income: 'i',
    incomes: 'i-s',
    expense: 'e',
    expenses: 'e-s',
    expenseName: 'eN',
    events: 'ev-s',
    assets: 'a-s',
    liabilities: 'l-s',
    monthlyPayment: 'mP',
    data: 'da',
    availableCount: 'aC',
    currentPrice: 'cP',
    fairPrice: 'fP',
    profitabilityPercent: 'pP',
    businessId: 'bI',
    downPayment: 'dP',
    passiveIncomePerMonth: 'pIPM',
    payback: 'pa-k',
    sellProbability: 'sP-y',
    insuranceType: 'iT',
    assetName: 'aN',
    duration: 'dur',
    price: 'p',
    nominal: 'no',
    profitability: 'pr-y',
    stepValue: 'sV',
    cashFlow: 'cF',
    credit: 'cr',
    averagePrice: 'aP',
    countInPortfolio: 'cIP',
    count: 'cnt',
    buyPrice: 'bP',
    targetValue: 'tV',
    userId: 'uI',
    cost: 'co',
    fromMonth: 'fM',
    realEstateId: 'rEI',
    max: 'mx',
    min: 'mn',
  };

  const valueMinifiers = {
    player_move: 'p_m',
    players_move: 'p-s_m',
    month_result: 'm_r',
    game_over: 'g_o',
    passive_income: 'p_i',
    singleplayer: 'sp',
    multiplayer: 'mp',
    mortgage: 'mor-e',
    business_credit: 'b_c',
    other: 'o-r',
    real_estate_credit: 'r_e_c',
    salary: 's-y',
    realty: 'r-y',
    investment: 'i-t',
    business: 'b-s',
    insurance: 'ins-e',
    debenture: 'd-e',
    stock: 's-k',
    cash: 'c-h',
    health: 'h-h',
    property: 'p-y',
    'income-event': 'i-e',
    'expense-event': 'e-e',
    'debenture-price-changed-event': 'd-p-c-e',
    'stock-price-changed-event': 's-p-c-e',
    'business-buy-event': 'b-b-e',
    'business-sell-event': 'b-s-e',
    'monthly-expense-event': 'm-e-e',
    'real-estate-buy-event': 'r-e-b-e',
    'salary-change-event': 's-c-e',
    'insurance-event': 'ins-ev',
  };

  const keyNormalizers = {};
  const valueNormalizers = {};

  export const minify = (game: Game): Object => {
    const minifiedGame = minifyValue(game);

    const initialGameJson = JSON.stringify(game);
    const minifiedGameJson = JSON.stringify(minifiedGame);
    const compressionRate = minifiedGameJson.length / initialGameJson.length;

    console.log(
      `COMPRESSION RATE: ${(compressionRate * 100).toFixed(2)}%\n` +
        `INITIAL VERSION SIZE: ${((initialGameJson.length * 2) / 1024).toFixed(2)} KB\n` +
        `MINIFIED VERSION SIZE: ${((minifiedGameJson.length * 2) / 1024).toFixed(2)} KB`
    );

    return minifiedGame;
  };

  const minifyValue = (value: any) => {
    if (typeof value === 'object' && !Array.isArray(value)) {
      const minifiedObject = {};

      for (const key in value) {
        if (Object.prototype.hasOwnProperty.call(value, key)) {
          const objectValue = minifyValue(value[key]);
          const minifiedKey = keyMinifiers[key] || key;

          minifiedObject[minifiedKey] = objectValue;
        }
      }

      return minifiedObject;
    }

    if (typeof value === 'string') {
      const minifiedString = valueMinifiers[value] || value;
      return minifiedString;
    }

    if (Array.isArray(value)) {
      const minifiedArray = value.map(minifyValue);
      return minifiedArray;
    }

    return value;
  };

  export const normalize = (minifiedGame: Object): Game => {
    Object.keys(keyMinifiers).forEach((key) => {
      const normalForm = key;
      const minifiedForm = keyMinifiers[key];

      keyNormalizers[minifiedForm] = normalForm;
    });

    Object.keys(valueMinifiers).forEach((key) => {
      const normalForm = key;
      const minifiedForm = valueMinifiers[key];

      valueNormalizers[minifiedForm] = normalForm;
    });

    return normalizeValue(minifiedGame) as Game;
  };

  const normalizeValue = (value: any) => {
    if (typeof value === 'object' && !Array.isArray(value)) {
      const normalizedObject = {};

      for (const key in value) {
        if (Object.prototype.hasOwnProperty.call(value, key)) {
          const objectValue = normalizeValue(value[key]);
          const normalKey = keyNormalizers[key] || key;

          normalizedObject[normalKey] = objectValue;
        }
      }

      return normalizedObject;
    }

    if (typeof value === 'string') {
      const normalizedString = valueNormalizers[value] || value;
      return normalizedString;
    }

    if (Array.isArray(value)) {
      const normalizedArray = value.map(normalizeValue);
      return normalizedArray;
    }

    return value;
  };
}
