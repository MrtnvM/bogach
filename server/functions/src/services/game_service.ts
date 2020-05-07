import { GameEntity, Game } from '../models/domain/game/game';
import { GameProvider } from '../providers/game_provider';
import { DebenturePriceChangedEventGenerator } from '../events/debenture/debenture_price_changed_event_generator';
import { produce } from 'immer';
import { GameEventEntity, GameEvent } from '../models/domain/game/game_event';
import { GameContext } from '../models/domain/game/game_context';
import { PlayerActionHandler } from '../core/domain/player_action_handler';
import { DebenturePriceChangedHandler } from '../events/debenture/debenture_price_changed_handler';
import { StockPriceChangedHandler } from '../events/stock/stock_price_changed_handler';
import { BusinessBuyEventHandler } from '../events/business/buy/business_buy_event_handler';
import { PossessionStateGenerator } from './possession_state_generator';
import { GameTargetEntity } from '../models/domain/game/game_target';
import { UserEntity } from '../models/domain/user';

export class GameService {
  constructor(
    private gameProvider: GameProvider,
    private possessionStateGenerator: PossessionStateGenerator
  ) {
    this.handlers.forEach((handler) => {
      this.handlerMap[handler.gameEventType] = handler;
    });
  }

  private handlers: PlayerActionHandler[] = [
    new DebenturePriceChangedHandler(),
    new StockPriceChangedHandler(),
    new BusinessBuyEventHandler(),
  ];

  // private sellBusinessEventProvider = new BusinessSellEventProvider(
  //   new BusinessSellEventGenerator()
  // );

  private handlerMap: { [type: string]: PlayerActionHandler } = {};

  async updateEvents(gameId: GameEntity.Id): Promise<Game> {
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
      // StockPriceChangedEventGenerator.generate(),
      // StockPriceChangedEventGenerator.generate(),
      // StockPriceChangedEventGenerator.generate(),
      // BusinessBuyEventGenerator.generate(),
      // BusinessBuyEventGenerator.generate(),
      // BusinessBuyEventGenerator.generate(),
      // ...this.sellBusinessEventProvider.generateBusinessSellEvent(game),
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

    if (game.state.gameStatus === 'game_over') {
      return;
    }

    await handler.validate(event, action);
    game = await handler.handle(game, event, action, userId);

    const gameTransformers: ((game: Game) => Game)[] = [
      (g) => this.updateParticipantsAccounts(g),
      (g) => this.updateMonth(g),
      (g) => this.updateWinners(g),
      (g) => this.updateGameEvents(g),
      (g) => this.updatePossessionState(g),
      (g) => this.updateUserProgress(g, eventId, userId),
    ];

    const updatedGame = gameTransformers.reduce((prev, func) => func(prev), game);

    await this.gameProvider.updateGame(updatedGame);
  }

  private updateUserProgress(game: Game, eventId: GameEntity.Id, userId: UserEntity.Id): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    const currentUserProgress = game.currentEvents.findIndex((e) => e.id === eventId);
    const isNotLastEvent = currentUserProgress < game.currentEvents.length - 1;
    let newUserProgress: number;

    if (isNotLastEvent) {
      newUserProgress = currentUserProgress + 1;
    } else {
      newUserProgress = isMoveCompleted ? 0 : currentUserProgress;
    }

    return produce(game, (draft) => {
      draft.state.participantProgress[userId] = newUserProgress;
    });
  }

  private updateMonth(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const monthNumber = game.state.monthNumber + (isMoveCompleted ? 1 : 0);

    return produce(game, (draft) => {
      draft.state.monthNumber = monthNumber;
    });
  }

  private updateWinners(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    const usersProgress = game.participants
      .map((participantId) => ({
        participantId,
        progress: GameTargetEntity.calculateProgress(game, participantId),
      }))
      .sort((p1, p2) => p2.progress - p1.progress);

    const winners: { [place: number]: string } = usersProgress.reduce((prev, curr, index) => {
      return { ...prev, [index]: curr.participantId };
    }, {});

    const isTargetArchived = usersProgress[0].progress >= 1;

    const gameStatus: GameEntity.Status =
      isTargetArchived && isMoveCompleted ? 'game_over' : game.state.gameStatus;

    return produce(game, (draft) => {
      draft.state.gameStatus = gameStatus;
      draft.state.winners = winners;
    });
  }

  private updateParticipantsAccounts(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    if (!isMoveCompleted) {
      return game;
    }

    const accounts = produce(game.accounts, (draft) => {
      game.participants.forEach((participantId) => {
        const participantAccount = draft[participantId];
        participantAccount.cash += participantAccount.cashFlow;
      });
    });

    return produce(game, (draft) => {
      draft.accounts = accounts;
    });
  }

  private updateGameEvents(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const gameEvents = isMoveCompleted ? this.generateGameEvents(game) : game.currentEvents;

    return produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });
  }

  private updatePossessionState(game: Game): Game {
    const possessionState = this.possessionStateGenerator.generateParticipantsPossessionState(game);

    return produce(game, (draft) => {
      draft.possessionState = possessionState;
    });
  }

  private isAllParticipantsCompletedMove(game: Game): boolean {
    return game.participants
      .map((participantId) => {
        const currentEventNumber = game.state.participantProgress[participantId];
        const isLastEvent = currentEventNumber === game.currentEvents.length - 1;
        return isLastEvent;
      })
      .reduce((prev, curr) => prev && curr, true);
  }
}
