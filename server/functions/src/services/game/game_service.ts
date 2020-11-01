import { GameProvider } from '../../providers/game_provider';
import { GameLevelsProvider } from '../../providers/game_levels_provider';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { GameContext } from '../../models/domain/game/game_context';
import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { DebentureEventHandler } from '../../events/debenture/debenture_event_handler';
import { StockEventHandler } from '../../events/stock/stock_event_handler';
import { BusinessBuyEventHandler } from '../../events/business/buy/business_buy_event_handler';
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
  UpdateMoveStartDateTransformer,
} from '../../transformers/game_transformers';
import { IncomeHandler } from '../../events/income/income_handler';
import { ExpenseHandler } from '../../events/expense/expense_handler';
import { BusinessSellEventHandler } from '../../events/business/sell/business_sell_event_handler';
import { MonthlyExpenseEventHandler } from '../../events/monthly_expense/monthly_expense_event_handler';
import { InsuranceHandler } from '../../events/insurance/insurance_handler';
import { SalaryChangeEventHandler } from '../../events/salary_change/salary_change_event_handler';
import { UserEntity } from '../../models/domain/user/user';
import { InsuranceTransformer } from '../../transformers/game/insurance_transformer';
import { ResetEventIndexTransformer } from '../../transformers/game/reset_event_index_transformer';
import { RealEstateBuyEventHandler } from '../../events/estate/buy/real_estate_buy_event_handler';
import { GameLevelEntity } from '../../game_levels/models/game_level';
import { UserProvider } from '../../providers/user_provider';
import { TimerProvider } from '../../providers/timer_provider';
import { Game, GameEntity } from '../../models/domain/game/game';
import { GameTemplateEntity } from '../../game_templates/models/game_template';

export class GameService {
  constructor(
    private gameProvider: GameProvider,
    private gameLevelsProvider: GameLevelsProvider,
    private userProvider: UserProvider,
    private timerProvider: TimerProvider
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

    if (createdGame.type === 'multiplayer') {
      this.timerProvider.scheduleTimer({
        startDateInUTC: createdGame.state.moveStartDateInUTC,
        gameId: createdGame.id,
        monthNumber: 1,
      });
    }

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
      new UpdateMoveStartDateTransformer(),
      new MonthTransformer(),
    ]);

    if (game.state.monthNumber < updatedGame.state.monthNumber) {
      this.scheduleCompleteMonthTimer(updatedGame);
    }

    await this.gameProvider.updateGame(updatedGame);
    await this.removeCompletedGameFromLastGamesIfNeeded(updatedGame);
    await this.updateCurrentUserQuestIndexIfNeeded(updatedGame, userId);
  }

  async startNewMonth(context: GameContext) {
    const { gameId, userId } = context;

    const game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const participantProgress = game.state.participantsProgress[userId];

    let updatedGame: Game | undefined;

    if (participantProgress.status === 'month_result') {
      const now = new Date();
      const moveStartDate = new Date(game.state.moveStartDateInUTC);
      const diff = now.getTime() - moveStartDate.getTime();
      const diffInMinutes = diff / 1000 / 60;
      const shouldScheduleMoveTimer = diffInMinutes > 1.0;

      updatedGame = applyGameTransformers(game, [
        new ResetEventIndexTransformer(userId),
        new InsuranceTransformer(userId),
        new PossessionStateTransformer(),
        ...(shouldScheduleMoveTimer ? [new UpdateMoveStartDateTransformer(true)] : []),
      ]);

      if (shouldScheduleMoveTimer) {
        this.scheduleCompleteMonthTimer(updatedGame);
      }

      updatedGame = await this.gameProvider.updateGame(updatedGame);
      return updatedGame;
    }

    return undefined;
  }

  async completeMonth(gameId: GameEntity.Id, monthNumber: number) {
    const game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const isGameCompleted = game.state.gameStatus === 'game_over';

    const isTheSameMonth = game.state.monthNumber === monthNumber;
    const atLeastOneParticipantStartedNewMonth = game.participants.some((id) => {
      return game.state.participantsProgress[id].currentMonthForParticipant === monthNumber;
    });
    const canCompleteMonth = isTheSameMonth && atLeastOneParticipantStartedNewMonth;

    if (isGameCompleted || !canCompleteMonth) {
      return;
    }

    const updatedGame = applyGameTransformers(game, [
      ...game.participants.map((participantId) => {
        const eventId = undefined;
        const shouldCompleteMonth = true;

        return new UserProgressTransformer(eventId, participantId, shouldCompleteMonth);
      }),

      new ParticipantAccountsTransformer(),
      new PossessionStateTransformer(),
      new WinnersTransformer(),
      new HistoryGameTransformer(),
      new GameEventsTransformer(),
      new MonthResultTransformer(),
      new UpdateMoveStartDateTransformer(),
      new MonthTransformer(),
    ]);

    if (updatedGame.state.monthNumber > monthNumber) {
      this.scheduleCompleteMonthTimer(updatedGame);
    }

    await this.gameProvider.updateGame(updatedGame);
  }

  async updateCurrentUserQuestIndexIfNeeded(game: Game, userId: UserEntity.Id) {
    const shouldOpenNewQuestForUser =
      game.state.gameStatus === 'game_over' &&
      game.config.level !== null &&
      game.state.participantsProgress[userId].progress >= 1;

    if (!shouldOpenNewQuestForUser) {
      return;
    }

    const gameLevels = this.gameLevelsProvider.getGameLevels();
    const questIndex = gameLevels.findIndex((l) => l.id === game.config.level);
    const newQuestIndex = Math.min(questIndex + 1, gameLevels.length - 1);

    await this.userProvider.updateCurrentQuestIndex(userId, newQuestIndex);
  }

  async removeCompletedGameFromLastGamesIfNeeded(game: Game) {
    if (game.state.gameStatus === 'game_over') {
      const removeCompletedGameOperations = game.participants.map((participantId) =>
        this.userProvider.removeGameFromLastGames(participantId, game.id)
      );

      await Promise.all(removeCompletedGameOperations);
    }
  }

  private scheduleCompleteMonthTimer(updatedGame: Game) {
    const isMultiplayerGame = updatedGame.type === 'multiplayer';
    if (!isMultiplayerGame) {
      return;
    }

    this.timerProvider.scheduleTimer({
      startDateInUTC: updatedGame.state.moveStartDateInUTC,
      gameId: updatedGame.id,
      monthNumber: updatedGame.state.monthNumber,
    });
  }
}
