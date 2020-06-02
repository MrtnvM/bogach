import { GameProvider } from '../providers/game_provider';
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
  applyGameTransformers,
} from '../transformers/game_transformers';
import { IncomeHandler } from '../events/income/income_handler';
import { ExpenseHandler } from '../events/expense/expense_handler';
import { BusinessSellEventHandler } from '../events/business/sell/business_sell_event_handler';
import { UserEntity } from '../models/domain/user';
import { GameTemplateEntity } from '../models/domain/game/game_template';
import { Room, RoomEntity } from '../models/domain/room';
import { checkIds } from '../core/validation/type_checks';

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
    new BusinessSellEventHandler(),
    new IncomeHandler(),
    new ExpenseHandler(),
  ];

  private handlerMap: { [type: string]: PlayerActionHandler } = {};

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
      new ParticipantAccountsTransformer(),
      new MonthTransformer(),
      new WinnersTransformer(),
      new GameEventsTransformer(),
      new PossessionStateTransformer(),
      new UserProgressTransformer(eventId, userId),
    ]);

    await this.gameProvider.updateGame(updatedGame);
  }

  createRoom(
    gameTemplateId: GameTemplateEntity.Id,
    participantsIds: UserEntity.Id[],
    currentUserId: UserEntity.Id
  ): Promise<Room> {
    return this.gameProvider.createRoom(gameTemplateId, participantsIds, currentUserId);
  }

  async onParticipantReady(roomId: RoomEntity.Id, participantId: UserEntity.Id) {
    checkIds([roomId, participantId]);

    const room = await this.gameProvider.setParticipantReady(roomId, participantId);

    const gameIsNotCreatedYet = !room.gameId;
    const isAllParticipantsReady = room.participants.every((p) => p.status === 'ready');

    if (gameIsNotCreatedYet && isAllParticipantsReady) {
      this.gameProvider.createRoomGame(room.id);
    }
  }

  /// Creation of room game by force without waitng of all players
  async createRoomGame(roomId: RoomEntity.Id) {
    this.gameProvider.createRoomGame(roomId);
  }
}
