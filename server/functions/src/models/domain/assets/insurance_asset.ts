import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface InsuranceAsset extends Asset {
  readonly cost: number;
  readonly value: number;
  readonly movesLeft: number;
  readonly insuranceType: InsuranceAssetEntity.InsuranceType;
}


export namespace InsuranceAssetEntity {
  export type InsuranceType = 'health' | 'property';
  export const TypeValues = ['health', 'property'];

  export const parse = (asset: Asset, data: any): InsuranceAsset => {
    const { cost, value, movesLeft, insuranceType } = data;

    return { ...asset, cost, value, movesLeft, insuranceType };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<InsuranceAsset>(asset, 'Insurance Asset');

    entity.hasNumberValue('cost');
    entity.hasNumberValue('value');
    entity.hasNumberValue('movesLeft');
    entity.checkUnion('insuranceType', TypeValues);

    entity.checkWithRules([
      [(a) => a.cost <= 0, "Down payment can't be <= 0"],
      [(a) => a.value <= 0, "Insurance value can't be <= 0"],
      [(a) => a.movesLeft <= 0, "MovesLeft value can't be <= 0"],
    ]);
  };
}
