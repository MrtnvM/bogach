import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { GameEvent } from '../../models/domain/game/game_event';
import { DebenturePriceChangedEventGenerator } from '../../events/debenture/debenture_price_changed_event_generator';
import { StockPriceChangedEventGenerator } from '../../events/stock/stock_price_changed_event_generator';
import { IncomeEventGenerator } from '../../events/income/income_event_generator';
import { BusinessBuyEventGenerator } from '../../events/business/buy/business_buy_event_generator';

export class GameEventsTransformer extends GameTransformer {
  constructor(private force: boolean = false) {
    super();
  }

  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const shouldGenerateEvents = isMoveCompleted || this.force;
    const gameEvents = shouldGenerateEvents ? this.generateGameEvents(game) : game.currentEvents;

    return produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });
  }

  private generateGameEvents(game: Game): GameEvent[] {
    const gameEvents = [
      DebenturePriceChangedEventGenerator.generate(),
      //DebenturePriceChangedEventGenerator.generate(),
      // DebenturePriceChangedEventGenerator.generate(),
      StockPriceChangedEventGenerator.generate(),
      // StockPriceChangedEventGenerator.generate(),
      // StockPriceChangedEventGenerator.generate(),
      BusinessBuyEventGenerator.generate(),
      BusinessBuyEventGenerator.generate(),
      //BusinessBuyEventGenerator.generate(),
      // ...this.sellBusinessEventProvider.generateBusinessSellEvent(game),
      DebenturePriceChangedEventGenerator.generate(),
      IncomeEventGenerator.generate(),
    ];

    return gameEvents;
  }
}
