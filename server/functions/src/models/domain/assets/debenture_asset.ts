import { Asset } from '../asset';
import { Income } from '../income';
import { Strings } from '../../../resources/strings';
import { Entity } from '../../../core/domain/entity';

export interface DebentureAsset extends Asset {
  currentPrice: number;
  nominal: number;
  profitabilityPercent: number;
}

export namespace DebentureAssetEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<DebentureAsset>(asset);

    entity.hasNumberValue('currentPrice');
    entity.hasNumberValue('nominal');
    entity.hasNumberValue('profitabilityPercent');
  };

  export const getIncome = (asset: DebentureAsset): Income => {
    validate(asset);

    const incomeValue = (asset.nominal * asset.profitabilityPercent) / 100;

    return {
      name: Strings.debetures(),
      value: incomeValue,
      type: 'investment'
    };
  };
}
