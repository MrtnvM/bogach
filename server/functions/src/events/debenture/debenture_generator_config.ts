import { ValueRange } from '../../core/data/value_range';

export namespace DebentureGeneratorConfig {
  type Config = {
    readonly nameOptions: string[];
    readonly nominal: ValueRange;
    readonly price: ValueRange;
    readonly profitability: ValueRange;
  };

  export const govermentDebenture: Config = {
    nameOptions: ['ОФЗ 29006', 'ОФЗ 29007', 'ОФЗ 29009', 'ОФЗ 26233', 'ОФЗ 26227'],
    nominal: { min: 1000, max: 1000, stepValue: 0 },
    price: { min: 850, max: 1300, stepValue: 10 },
    profitability: { min: 5.8, max: 8.9, stepValue: 0.1 },
  };

  export const regionalDebenture: Config = {
    nameOptions: [
      'Республика Якутия',
      'Оренбургская область',
      'Ненецкий АО',
      'Томская область',
      'Ульяновская область',
      'Калининградская область',
      'Санкт-Петербург',
      'Московская область',
    ],
    nominal: { min: 1000, max: 1000, stepValue: 0 },
    price: { min: 850, max: 1300, stepValue: 10 },
    profitability: { min: 6.3, max: 9.2, stepValue: 0.1 },
  };

  export const corporateDebenture: Config = {
    nameOptions: [
      'ПИК',
      'Башнефть БО-06',
      'Роснано выпуск 8',
      'Эталон выпуск 8',
      'Норильский никель выпуск 5',
      'АФК Система выпуск 12',
      'РЖД 001Р выпуск 14',
      'Детский мир выпуск 5',
      'Ростелеком 002Р выпуск 2',
    ],
    nominal: { min: 1000, max: 1000, stepValue: 0 },
    price: { min: 850, max: 1300, stepValue: 10 },
    profitability: { min: 7.0, max: 12.5, stepValue: 0.1 },
  };

  export const getConfig = (debentureName: string): Config => {
    if (govermentDebenture.nameOptions.indexOf(debentureName) >= 0) {
      return govermentDebenture;
    }

    if (regionalDebenture.nameOptions.indexOf(debentureName) >= 0) {
      return regionalDebenture;
    }

    if (corporateDebenture.nameOptions.indexOf(debentureName) >= 0) {
      return corporateDebenture;
    }

    throw new Error('ERROR: Can not find debenture config by name');
  };
}
