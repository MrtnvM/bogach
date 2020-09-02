import { Rule } from '../generator_rule';
import { GameEvent } from '../../models/domain/game/game_event';
import { BusinessSellEvent } from '../../events/business/sell/business_sell_event';
import { BusinessSellEventGenerator } from '../../events/business/sell/business_sell_event_generator';
import { BusinessBuyEvent } from '../../events/business/buy/business_buy_event';
import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { Game } from '../../models/domain/game/game';

export class BusinessSellGenerateRule extends Rule<BusinessSellEvent.Event> {
  getProbabilityLevel(): number {
    return 4;
  }

  generate(game: Game) {
    const buyEvent = this.findBuyEvent(game.currentEvents);

    if (!buyEvent) {
      return undefined;
    }

    const event = BusinessSellEventGenerator.generate(buyEvent);
    return event;
  }

  getMinDistanceBetweenEvents(): number {
    return 10;
  }

  getType(): string {
    return BusinessSellEvent.Type;
  }

  //TODO: fix issue with 2 buy events without sell events
  findBuyEvent(events: GameEvent[]): BusinessAsset | undefined {
    /// Fix of the bug
    /// We can't apply the reverse method to immutable array
    /// Reverse method is mutating the array
    const copyOfEventsArray = [...events];
    const reversedEvents = copyOfEventsArray.reverse();

    const buyEvent = reversedEvents.find((item) => item.type === BusinessBuyEvent.Type)?.data;
    return buyEvent !== undefined ? undefined : (buyEvent as BusinessAsset);
  }
}
