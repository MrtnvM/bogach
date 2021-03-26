import * as uuid from 'uuid';
import { BusinessSellEvent } from './business_sell_event';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';
import { randomValueFromRange, valueRange } from '../../../core/data/value_range';

// TODO добавить реальные данные
export namespace BusinessSellEventGenerator {
  export const generate = (businessAsset: BusinessAsset): BusinessSellEvent.Event => {
    const businessId = businessAsset.id as string;
    const name = 'Предложение продать ' + businessAsset.name;

    return generateEvent({
      name,
      description: 'Описание продаваемого бизнеса',
      businessId,
      price: valueRange([70_000, 150_000, 1000]),
    });
  };

  export const generateEvent = (businessInfo: BusinessSellEvent.Info): BusinessSellEvent.Event => {
    const { name, description, price, businessId } = businessInfo;

    return {
      id: uuid.v4(),
      name,
      description,
      type: BusinessSellEvent.Type,
      data: {
        businessId,
        currentPrice: randomValueFromRange(price),
      },
    };
  };
}
