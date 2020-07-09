import { Rule } from "../generator_rule";
import { RealEstateBuyEvent } from "../../events/estate/buy/real_estate_buy_event";
import { Game } from "../../models/domain/game/game";
import { BuyRealEstateEventGenerator } from "../../events/estate/buy/real_estate_buy_event_generator";

export class RealEstateBuyRule extends Rule<RealEstateBuyEvent.Event> {
    getProbabilityLevel(): number {
      return 10;
    }
  
    generate(game: Game) {
      return BuyRealEstateEventGenerator.generate(game);
    }
  
    getMinDistanceBetweenEvents(): number {
      return 1;
    }
  
    getType(): string {
      return RealEstateBuyEvent.Type;
    }
  }
  