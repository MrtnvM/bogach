import { Game } from '../../models/domain/game/game';
import { BusinessSellEvent } from '../../events/business/sell/business_sell_event';
import { BusinessSellEventGenerator } from '../../events/business/sell/business_sell_event_generator';
import { BusinessAsset } from '../../models/domain/assets/business_asset';
import * as random from 'random';
import { Possessions } from '../../models/domain/possessions';

export class BusinessSellEventProvider {
  constructor(private businessSellEventGenerator: BusinessSellEventGenerator) {}

  generateBusinessSellEvent(game: Game): BusinessSellEvent.Event[] {
    let businessSellEvents: BusinessSellEvent.Event[] = [];
    const participants = game.participants;

    participants.forEach((participant) => {
      const possessions = game.possessions[participant];
      const businessSellEventForUser = this.generateEventsForUserPossessions(possessions);
      businessSellEvents = businessSellEvents.concat(businessSellEventForUser);
    });

    return businessSellEvents;
  }

  private generateEventsForUserPossessions(possessions: Possessions): BusinessSellEvent.Event[] {
    const businessSellEvents: BusinessSellEvent.Event[] = [];
    for (const asset of possessions.assets) {
      if (asset.type !== 'business') {
        continue;
      }

      const businessAsset = asset as BusinessAsset;

      const sellProbability = random.int(0, 100);
      if (sellProbability >= businessAsset.sellProbability) {
        continue;
      }

      const businessSellEvent = this.businessSellEventGenerator.generate(asset as BusinessAsset);
      businessSellEvents.push(businessSellEvent);
    }

    return businessSellEvents;
  }
}
