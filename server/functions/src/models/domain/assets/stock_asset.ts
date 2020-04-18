import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface StockAsset extends Asset {
  readonly currentPrice: number;
  readonly fairPrice: number;
  readonly count: number;
}

export namespace StockAssetEntity {
  export const parse = (asset: Asset, data: any): StockAsset => {
    const { currentPrice, fairPrice, portfolioCount, count } = data;

    return { ...currentPrice, fairPrice, portfolioCount, maxCount: count };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<StockAsset>(asset, 'Stock Asset');

    entity.hasNumberValue('currentPrice');
    entity.hasNumberValue('fairPrice');
    entity.hasNumberValue('count');

    entity.checkWithRules([
      [a => a.currentPrice <= 0, "CurrentPrice price can't be <= 0"],
      [a => a.fairPrice <= 0, "FairPrice can't be <= 0"],
      [a => a.count < 0, "Count can't be < 0"]
    ]);
  };
}
