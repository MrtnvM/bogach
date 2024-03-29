import * as random from 'random';
import { Game } from '../../models/domain/game/game';
import { BusinessSellEvent } from '../../events/business/sell/business_sell_event';
import { BusinessSellEventGenerator } from '../../events/business/sell/business_sell_event_generator';
import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { Possessions } from '../../models/domain/possessions';

export class BusinessSellEventProvider {
  generateBusinessSellEvent(game: Game): BusinessSellEvent.Event[] {
    let businessSellEvents: BusinessSellEvent.Event[] = [];
    const participants = game.participantsIds;

    participants.forEach((participantId) => {
      const possessions = game.participants[participantId].possessions;
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

      const sellProbability = random.int(0, 101);
      if (sellProbability >= businessAsset.sellProbability) {
        continue;
      }

      const businessSellEvent = BusinessSellEventGenerator.generate(asset as BusinessAsset);
      businessSellEvents.push(businessSellEvent);
    }

    return businessSellEvents;
  }
}
