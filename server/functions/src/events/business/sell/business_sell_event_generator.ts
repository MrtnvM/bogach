import * as uuid from 'uuid';
import * as random from 'random';
import { BusinessSellEvent } from './business_sell_event';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';

// TODO добавить реальные данные
export class BusinessSellEventGenerator {
  generate = (businessAsset: BusinessAsset): BusinessSellEvent.Event => {
    const businessId = businessAsset.id as string;
    const currentPrice = random.int(70, 150) * 1000;
    const name = 'Предложение продать ' + businessAsset.name;

    return {
      id: uuid.v4(),
      name: name,
      description: 'Описание продаваемого бизнеса',
      type: BusinessSellEvent.Type,
      data: {
        businessId,
        currentPrice,
      },
    };
  };
}
