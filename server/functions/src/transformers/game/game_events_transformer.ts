import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { GameEvent } from '../../models/domain/game/game_event';
import { BusinessBuyEventGenerator } from '../../events/business/buy/business_buy_event_generator';
import { IncomeEventGenerator } from '../../events/income/income_event_generator';
import { ExpenseEventGenerator } from '../../events/expense/expense_event_generator';
import { StockPriceChangedEventGenerator } from '../../events/stock/stock_price_changed_event_generator';
import { DebenturePriceChangedEventGenerator } from '../../events/debenture/debenture_price_changed_event_generator';
import { ChildBornGenerator } from '../../events/monthly_expense/child_born/child_born_event_generator';
import { InsuranceEventGenerator } from '../../events/insurance/insurance_event_generator';

export class GameEventsTransformer extends GameTransformer {
  constructor(private force: boolean = false) {
    super();
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const shouldGenerateEvents = isMoveCompleted || this.force;
    const gameEvents = shouldGenerateEvents ? this.generateGameEvents(game) : game.currentEvents;

    return produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });
  }

  private generateGameEvents(game: Game): GameEvent[] {
    // const businessSellEventGenerator = new BusinessSellEventGenerator();
    // const businessSellEventProvider = new BusinessSellEventProvider(businessSellEventGenerator);

    const gameEventGenerators: ((game: Game) => GameEvent)[] = [
      (g) => InsuranceEventGenerator.generate(),
      (g) => ChildBornGenerator.generate(),
      (g) => ExpenseEventGenerator.generate(),
      (g) => DebenturePriceChangedEventGenerator.generate(),
      (g) => DebenturePriceChangedEventGenerator.generate(),
      (g) => DebenturePriceChangedEventGenerator.generate(),
      (g) => StockPriceChangedEventGenerator.generate(g),
      (g) => StockPriceChangedEventGenerator.generate(g),
      (g) => StockPriceChangedEventGenerator.generate(g),
      (g) => BusinessBuyEventGenerator.generate(),
      (g) => BusinessBuyEventGenerator.generate(),
      // (g) => businessSellEventProvider.generateBusinessSellEvent(game),
      (g) => IncomeEventGenerator.generate(),
      (g) => ExpenseEventGenerator.generate(),
    ];

    let updatedGame = game;
    let gameEvents: GameEvent[] = [];

    for (const generator of gameEventGenerators) {
      const gameEvent = generator(updatedGame);
      gameEvents = [...gameEvents, gameEvent];

      updatedGame = produce(updatedGame, (draft) => {
        draft.currentEvents = gameEvents;
      });
    }

    return gameEvents;
  }
}
