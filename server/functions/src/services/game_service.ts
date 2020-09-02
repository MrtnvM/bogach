import { GameProvider } from '../providers/game_provider';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { GameEventEntity } from '../models/domain/game/game_event';
import { GameContext } from '../models/domain/game/game_context';
import { PlayerActionHandler } from '../core/domain/player_action_handler';
import { DebentureEventHandler } from '../events/debenture/debenture_event_handler';
import { StockEventHandler } from '../events/stock/stock_event_handler';
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
import { SalaryChangeEventHandler } from '../events/salary_change/salary_change_event_handler';
import { UserEntity } from '../models/domain/user';
import { GameTemplateEntity } from '../models/domain/game/game_template';
import { InsuranceTransformer } from '../transformers/game/insurance_transformer';
import { ResetEventIndexTransformer } from '../transformers/game/reset_event_index_transformer';
import { RealEstateBuyEventHandler } from '../events/estate/buy/real_estate_buy_event_handler';
import { GameLevelEntity } from '../game_levels/models/game_level';
import { UserProvider } from '../providers/user_provider';
import { Game } from '../models/domain/game/game';

export class GameService {
  constructor(
    private gameProvider: GameProvider,
    private gameLevelsProvider: GameLevelsProvider,
    private userProvider: UserProvider
  ) {
    this.handlers.forEach((handler) => {
      this.handlerMap[handler.gameEventType] = handler;
    });
  }

  private handlers: PlayerActionHandler[] = [
    new DebentureEventHandler(),
    new StockEventHandler(),
    new BusinessBuyEventHandler(),
    new BusinessSellEventHandler(),
    new IncomeHandler(),
    new ExpenseHandler(),
    new MonthlyExpenseEventHandler(),
    new InsuranceHandler(),
    new RealEstateBuyEventHandler(),
    new SalaryChangeEventHandler(),
  ];

  private handlerMap: { [type: string]: PlayerActionHandler } = {};

  async createNewGame(templateId: GameTemplateEntity.Id, participantsIds: UserEntity.Id[]) {
    const createdGame = await this.gameProvider.createGame(templateId, participantsIds);
    return createdGame;
  }

  async createNewGameByLevel(levelId: GameLevelEntity.Id, participantsIds: UserEntity.Id[]) {
    const gameLevel = this.gameLevelsProvider.getGameLevel(levelId);
    const { template } = gameLevel;

    const createdGame = await this.gameProvider.createGameByTemplate(
      template,
      participantsIds,
      gameLevel
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
      new PossessionStateTransformer(),
      new WinnersTransformer(),
      new HistoryGameTransformer(),
      new GameEventsTransformer(),
      new MonthResultTransformer(),
      new MonthTransformer(),
    ]);

    await this.gameProvider.updateGame(updatedGame);
    await this.updateCurrentUserQuestIndexIfNeeded(updatedGame, userId);
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

  async updateCurrentUserQuestIndexIfNeeded(game: Game, userId: UserEntity.Id) {
    const shouldOpenNewQuestForUser =
      game.state.gameStatus === 'game_over' &&
      game.config.level != null &&
      game.state.participantsProgress[userId].progress >= 1;

    if (!shouldOpenNewQuestForUser) {
      return;
    }

    const gameLevels = this.gameLevelsProvider.getGameLevels();
    const questIndex = gameLevels.findIndex((l) => l.id === game.config.level);
    const newQuestIndex = Math.min(questIndex + 1, gameLevels.length - 1);

    await this.userProvider.updateCurrentQuestIndex(userId, newQuestIndex);
  }
}
