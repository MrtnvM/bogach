import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { DebenturePriceChangedEvent } from './debenture_price_changed_event';
import { formatPrice } from '../../utils/currency';
import { Game } from '../../models/domain/game/game';
import { DebentureGeneratorConfig } from './debenture_generator_config';

export namespace DebenturePriceChangedEventGenerator {
  export const generate = (game: Game): DebenturePriceChangedEvent.Event => {
    const debentureIndex = random.int(0, game.config.debentures.length - 1);
    const debenture = game.config.debentures[debentureIndex];
    const config = DebentureGeneratorConfig.getConfig(debenture);

    const randomPrice = random.int(config.price.min, config.price.max);
    const currentPrice = randomPrice - (randomPrice % config.price.stepValue);

    const nominal = random.int(config.nominal.min, config.nominal.max);

    const randomPercent = random.float(config.profitability.min, config.profitability.max);
    const profitabilityPercent = randomPercent - (randomPercent % config.profitability.stepValue);

    const availableCount = random.int(9, 20) * 10;

    return {
      id: uuid.v4(),
      name: debenture,
      description: Strings.currentPrice() + formatPrice(currentPrice),
      type: DebenturePriceChangedEvent.Type,
      data: {
        currentPrice,
        nominal,
        profitabilityPercent,
        availableCount,
      },
    };
  };
}
