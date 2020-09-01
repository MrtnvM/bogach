import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { DebentureEvent } from './debenture_event';
import { formatPrice } from '../../utils/currency';
import { Game } from '../../models/domain/game/game';
import { randomValueFromRange } from '../../core/data/value_range';

export namespace DebentureEventGenerator {
  export const generate = (game: Game): DebentureEvent.Event => {
    const debentureIndex = random.int(0, game.config.debentures.length - 1);
    const debenture = game.config.debentures[debentureIndex];
    const event = generateEvent(debenture);
    return event;
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
