import { GameProvider } from '../providers/game_provider';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { GameEventEntity } from '../models/domain/game/game_event';
import { GameContext } from '../models/domain/game/game_context';
import { PlayerActionHandler } from '../core/domain/player_action_handler';
import { DebenturePriceChangedHandler } from '../events/debenture/debenture_price_changed_handler';
import { StockPriceChangedHandler } from '../events/stock/stock_price_changed_handler';
import { BusinessBuyEventHandler } from '../events/business/buy/business_buy_event_handler';
import {
  ParticipantAccountsTransformer,
  WinnersTransformer,
  MonthTransformer,
  GameEventsTransformer,
  PossessionStateTransformer,
  UserProgressTransformer,
  MonthResultTransformer,
  applyGameTransformers,
  HistoryGameTransformer,
} from '../transformers/game_transformers';
import { IncomeHandler } from '../events/income/income_handler';
import { ExpenseHandler } from '../events/expense/expense_handler';
import { BusinessSellEventHandler } from '../events/business/sell/business_sell_event_handler';
import { MonthlyExpenseEventHandler } from '../events/monthly_expense/monthly_expense_event_handler';
import { InsuranceHandler } from '../events/insurance/insurance_handler';
import { UserEntity } from '../models/domain/user';
import { GameTemplateEntity } from '../models/domain/game/game_template';
import { InsuranceTransformer } from '../transformers/game/insurance_transformer';
import { ResetEventIndexTransformer } from '../transformers/game/reset_event_index_transformer';
import { RealEstateBuyEventHandler } from '../events/estate/buy/real_estate_buy_event_handler';
import { GameLevelEntity } from '../models/domain/game_levels/game_level';

export class GameService {
  constructor(private gameProvider: GameProvider, private gameLevelsProvider: GameLevelsProvider) {
    this.handlers.forEach((handler) => {
      this.handlerMap[handler.gameEventType] = handler;
    });
  }

  private handlers: PlayerActionHandler[] = [
    new DebenturePriceChangedHandler(),
    new StockPriceChangedHandler(),
    new BusinessBuyEventHandler(),
    new BusinessSellEventHandler(),
    new IncomeHandler(),
    new ExpenseHandler(),
    new MonthlyExpenseEventHandler(),
    new InsuranceHandler(),
    new RealEstateBuyEventHandler(),
  ];

  private handlerMap: { [type: string]: PlayerActionHandler } = {};

  async createNewGame(templateId: GameTemplateEntity.Id, participantsIds: UserEntity.Id[]) {
    const createdGame = await this.gameProvider.createGame(templateId, participantsIds);
    return createdGame;
  }

  async createNewGameByLevel(levelId: GameLevelEntity.Id, participantsIds: UserEntity.Id[]) {
    const gameLevelConfig = this.gameLevelsProvider.getGameLevel(levelId);
    const { template } = gameLevelConfig;

    const createdGame = await this.gameProvider.createGameByTemplate(
      template,
      participantsIds,
      levelId
    );

    return createdGame;
  }

  async handlePlayerAction(eventId: GameEventEntity.Id, action: any, context: GameContext) {
    const { gameId, userId } = context;

    let game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const event = game.currentEvents.find((e) => e.id === eventId);
    if (!event) throw new Error('No game event with ID: ' + eventId);

    const handler = this.handlerMap[event.type];
    if (!handler) throw new Error('Event handler not found for event with ID: ' + eventId);

    if (game.state.gameStatus === 'game_over') {
      return;
    }

    if (action) {
      await handler.validate(event, action);
      game = await handler.handle(game, event, action, userId);
    }

    const updatedGame = applyGameTransformers(game, [
      new UserProgressTransformer(eventId, userId),
      new ParticipantAccountsTransformer(),
      new WinnersTransformer(),
      new PossessionStateTransformer(),
      new HistoryGameTransformer(),
      new GameEventsTransformer(),
      new MonthResultTransformer(),
      new MonthTransformer(),
    ]);

    await this.gameProvider.updateGame(updatedGame);
  }

  async startNewMonth(context: GameContext) {
    const { gameId, userId } = context;

    const game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const participantProgress = game.state.participantsProgress[userId];

    if (participantProgress.status === 'month_result') {
      const updatedGame = applyGameTransformers(game, [
        new ResetEventIndexTransformer(userId),
        new InsuranceTransformer(userId),
        new PossessionStateTransformer(),
      ]);

      await this.gameProvider.updateGame(updatedGame);
    }
  }
}
