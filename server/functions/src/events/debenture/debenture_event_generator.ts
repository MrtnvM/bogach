import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { DebentureEvent } from './debenture_event';
import { formatPrice } from '../../utils/currency';
import { Game } from '../../models/domain/game/game';
import { DebentureGeneratorConfig } from './debenture_generator_config';
import { randomValueFromRange, valueRange } from '../../core/data/value_range';

export namespace DebentureEventGenerator {
  export const generate = (game: Game): DebentureEvent.Event => {
    const debentureIndex = random.int(0, game.config.debentures.length - 1);
    const debenture = game.config.debentures[debentureIndex];
    const config = DebentureGeneratorConfig.getConfig(debenture);

    const { price, profitability, nominal } = config;

    return generateEvent({
      name: debenture,
      price,
      nominal,
      profitability,
      availableCount: valueRange([90, 200, 10]),
    });
  };

  export const generateEvent = (eventInfo: DebentureEvent.Info): DebentureEvent.Event => {
    const { name, nominal, price, profitability, availableCount } = eventInfo;

    const currentPrice = randomValueFromRange(price);
    const currentNominal = randomValueFromRange(nominal);
    const currentProfitability = randomValueFromRange(profitability);
    const currentAvailableCount = randomValueFromRange(availableCount);

    return {
      id: uuid.v4(),
      name,
      description: Strings.currentPrice() + formatPrice(currentPrice),
      type: DebentureEvent.Type,
      data: {
        currentPrice,
        nominal: currentNominal,
        profitabilityPercent: currentProfitability,
        availableCount: currentAvailableCount,
      },
    };
  };
}
