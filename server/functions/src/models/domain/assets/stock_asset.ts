import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';
import { Income } from '../income';

// TODO(Maxim): Implement dividend income
export interface StockAsset extends Asset {
  readonly fairPrice: number;
  readonly averagePrice: number;
  readonly countInPortfolio: number;
}

export namespace StockAssetEntity {
  export const parse = (asset: Asset, data: any): StockAsset => {
    const { currentPrice, fairPrice, averagePrice, countInPortfolio, maxCount } = data;

    return { ...currentPrice, fairPrice, averagePrice, countInPortfolio, maxCount };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<StockAsset>(asset, 'Stock Asset');

    entity.hasNumberValue('fairPrice');
    entity.hasNumberValue('averagePrice');
    entity.hasNumberValue('countInPortfolio');

    entity.checkWithRules([
      [(a) => a.fairPrice <= 0, "FairPrice can't be <= 0"],
      [(a) => a.averagePrice <= 0, "AveragePrice can't be <= 0"],
      [(a) => a.countInPortfolio < 0, "CountInPortfolio can't be < 0"],
    ]);
  };

  export const getIncomeValue = (asset: StockAsset) => {
    // TODO(Maxim): Implement dividend income
    return 0;
  };

  export const getIncome = (asset: StockAsset): Income | undefined => {
    return undefined;
  };
}
