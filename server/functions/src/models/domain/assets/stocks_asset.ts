import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface StocksAsset extends Asset {
  readonly purchasePrice: number;
  readonly count: number;
}

export namespace InsuranceAssetEntity {
  export const parse = (asset: Asset, data: any): StocksAsset => {
    const { purchasePrice, count } = data;

    return { ...asset, purchasePrice, count };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<StocksAsset>(asset, 'Insurance Asset');

    entity.hasNumberValue('purchasePrice');
    entity.hasNumberValue('count');

    entity.checkWithRules([
      [a => a.purchasePrice <= 0, "Purchase price can't be <= 0"],
      [a => a.count < 0, "Stocks count can't be < 0"]
    ]);
  };
}
