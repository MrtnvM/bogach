import { GameEntity, Game } from '../models/domain/game/game';
import { Account } from '../models/domain/account';
import { GameProvider } from '../providers/game_provider';
import { DebenturePriceChangedEventGenerator } from '../events/debenture/debenture_price_changed_event_generator';
import { produce } from 'immer';
import { GameEventEntity, GameEvent } from '../models/domain/game/game_event';
import { GameContext } from '../models/domain/game/game_context';
import { PlayerActionHandler } from '../core/domain/player_action_handler';
import { DebenturePriceChangedHandler } from '../events/debenture/debenture_price_changed_handler';
import { StockPriceChangedHandler } from '../events/stock/stock_price_changed_handler';
import { StockPriceChangedEventGenerator } from '../events/stock/stock_price_changed_event_generator';
import { BusinessBuyEventGenerator } from '../events/business/buy/business_buy_event_generator';
import { BusinessBuyEventHandler } from '../events/business/buy/business_buy_event_handler';
import { UserEntity } from '../models/domain/user';
import { ParticipantGameState } from '../models/domain/game/participant_game_state';

export class GameService {
  constructor(private gameProvider: GameProvider) {
    this.handlers.forEach((handler) => {
      this.handlerMap[handler.gameEventType] = handler;
    });
  }

  private handlers: PlayerActionHandler[] = [
    new DebenturePriceChangedHandler(),
    new StockPriceChangedHandler(),
    new BusinessBuyEventHandler(),
  ];

  private handlerMap: { [type: string]: PlayerActionHandler } = {};

  async updateGameEvents(gameId: GameEntity.Id): Promise<Game> {
    if (!gameId) throw new Error('Missing Game ID');

    const game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const gameEvents = this.generateGameEvents(game);

    const gameWithNewEvents = produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });

    const updatedGame = await this.gameProvider.updateGame(gameWithNewEvents);
    return updatedGame;
  }

  generateGameEvents(game: Game): GameEvent[] {
    const gameEvents = [
      DebenturePriceChangedEventGenerator.generate(),
      DebenturePriceChangedEventGenerator.generate(),
      DebenturePriceChangedEventGenerator.generate(),
      StockPriceChangedEventGenerator.generate(),
      StockPriceChangedEventGenerator.generate(),
      StockPriceChangedEventGenerator.generate(),
      BusinessBuyEventGenerator.generate(),
      BusinessBuyEventGenerator.generate(),
      BusinessBuyEventGenerator.generate(),
      DebenturePriceChangedEventGenerator.generate(),
    ];

    return gameEvents;
  }

  async handlePlayerAction(eventId: GameEventEntity.Id, action: any, context: GameContext) {
    const { gameId, userId } = context;

    let game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const event = game.currentEvents.find((e) => e.id === eventId);
    if (!event) throw new Error('No game event with ID: ' + eventId);

    const handler = this.handlerMap[event.type];
    if (!handler) throw new Error('Event handler not found for event with ID: ' + eventId);

    await handler.validate(event, action);
    game = await handler.handle(game, event, action, userId);

    const isAllUsersCompletedMove = game.participants
      .map((participantId) => {
        const currentEventNumber = game.state.participantProgress[participantId];
        const isLastEvent = currentEventNumber === game.currentEvents.length - 1;
        return isLastEvent;
      })
      .reduce((prev, curr) => prev && curr, true);

    const accounts = this.getUsersAccounts(game, isAllUsersCompletedMove);
    const userProgress = this.getUserProgress(game, userId, isAllUsersCompletedMove);

    const monthNumber = isAllUsersCompletedMove
      ? game.state.monthNumber + 1
      : game.state.monthNumber;

    const gameEvents = isAllUsersCompletedMove ? this.generateGameEvents(game) : game.currentEvents;

    game = produce(game, (draft) => {
      draft.accounts = accounts;
      draft.state.participantProgress[userId] = userProgress;
      draft.state.monthNumber = monthNumber;
      draft.currentEvents = gameEvents;
    });

    await this.gameProvider.updateGame(game);
  }

  private getUserProgress(
    game: Game,
    userId: UserEntity.Id,
    isAllUsersCompletedMove: boolean
  ): number {
    const currentUserProgress = game.state.participantProgress[userId];
    let newUserProgress;

    if (currentUserProgress < game.currentEvents.length - 1) {
      newUserProgress = currentUserProgress + 1;
    } else {
      newUserProgress = isAllUsersCompletedMove ? 0 : currentUserProgress;
    }

    return newUserProgress;
  }

  private getUsersAccounts(
    game: Game,
    isAllUsersCompletedMove: boolean
  ): ParticipantGameState<Account> {
    if (!isAllUsersCompletedMove) {
      return game.accounts;
    }

    const currentAccounts = game.accounts;
    const updatedAccounts = produce(currentAccounts, (draft) => {
      game.participants.forEach((participantId) => {
        const participantAccount = draft[participantId];
        participantAccount.cash += participantAccount.cashFlow;
      });
    });

    return updatedAccounts;
  }
}
