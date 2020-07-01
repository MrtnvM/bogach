import { ValueRange } from '../../../core/data/value_range';

export namespace BuyRealEstateGeneratorConfig {
  type BuyRealEstateInfo = {
    readonly eventName: string;
    readonly assetName: string;
    readonly price: ValueRange;
    readonly fairPrice: ValueRange;
    readonly downPayment: ValueRange;
    readonly passiveIncomePerMonth: ValueRange;
    readonly sellProbability: ValueRange;
  };

  export const garageEstate: BuyRealEstateInfo[] = [
    {
      eventName: 'Продаётся гараж',
      assetName: 'Гараж',
      price: { min: 100_000, max: 150_000, stepValue: 1000 },
      fairPrice: { min: 100_000, max: 150_000, stepValue: 1000 },
      downPayment: { min: 15_000, max: 25_000, stepValue: 100 },
      passiveIncomePerMonth: { min: -800, max: 800, stepValue: 100 },
      sellProbability: { min: 10, max: 17, stepValue: 1 },
    },
  ];

  export const allRealEstates: BuyRealEstateInfo[] = [
    ...garageEstate,
  ];
}
