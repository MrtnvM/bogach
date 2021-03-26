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

  export const flatEstate: BuyRealEstateInfo[] = [
    {
      eventName: 'Продаётся квартира',
      assetName: '1-комн. Квартира',
      price: { min: 900_000, max: 1_300_000, stepValue: 10_000 },
      fairPrice: { min: 1_000_000, max: 1_100_000, stepValue: 10_000 },
      downPayment: { min: 100_000, max: 250_000, stepValue: 1000 },
      passiveIncomePerMonth: { min: -8000, max: 8000, stepValue: 100 },
      sellProbability: { min: 10, max: 17, stepValue: 1 },
    },
    {
      eventName: 'Продаётся квартира',
      assetName: '2-комн. Квартира',
      price: { min: 1_200_000, max: 1_600_000, stepValue: 10_000 },
      fairPrice: { min: 1_400_000, max: 1_500_000, stepValue: 10_000 },
      downPayment: { min: 150_000, max: 300_000, stepValue: 1000 },
      passiveIncomePerMonth: { min: -10_000, max: 10_000, stepValue: 100 },
      sellProbability: { min: 10, max: 17, stepValue: 1 },
    },
  ];

  export const allRealEstates: BuyRealEstateInfo[] = [...garageEstate, ...flatEstate];
}
