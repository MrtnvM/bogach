import { FirebaseMessaging } from '../core/firebase/firebase_messaging';
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
import { MonthlyExpenseEventHandler } from '../events/monthly_expense/monthly_expense_event_handler';
import { UserEntity } from '../models/domain/user';
import { GameTemplateEntity } from '../models/domain/game/game_template';
import { Room, RoomEntity } from '../models/domain/room';
import { checkIds } from '../core/validation/type_checks';
import { Strings } from '../resources/strings';
import { Game } from '../models/domain/game/game';

export class GameService {
  constructor(private gameProvider: GameProvider, private firebaseMessaging: FirebaseMessaging) {
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
  ];

  private handlerMap: { [type: string]: PlayerActionHandler } = {};

  async createNewGame(templateId: GameTemplateEntity.Id, participantsIds: UserEntity.Id[]) {
    const createdGame = await this.gameProvider.createGame(templateId, participantsIds);
    const newGame = this.intializeGame(createdGame);

    await this.gameProvider.updateGame(newGame);
    return newGame;
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
      new MonthTransformer(),
      new WinnersTransformer(),
      new PossessionStateTransformer(),
      new GameEventsTransformer(),
    ]);

    await this.gameProvider.updateGame(updatedGame);
  }

  async createRoom(
    gameTemplateId: GameTemplateEntity.Id,
    participantsIds: UserEntity.Id[],
    currentUserId: UserEntity.Id
  ): Promise<Room> {
    const room = await this.gameProvider.createRoom(gameTemplateId, participantsIds, currentUserId);

    const pushTokens = room.participants
      .filter((p) => p.id !== room.owner.id)
      .map((p) => p.deviceToken)
      .filter((token) => token);

    this.firebaseMessaging
      .sendMulticastNotification({
        title: Strings.battleInvitationNotificationTitle(),
        body: room.owner.userName + ' ' + Strings.battleInvitationNotificationBody(),
        data: {
          roomId: room.id,
          type: 'go_to_room',
        },
        pushTokens,
      })
      .catch((e) => {
        // TODO(Maxim): Process failed invites
        console.error('Failed sending room participant invites: ' + e);
      });

    return room;
  }

  async onParticipantReady(roomId: RoomEntity.Id, participantId: UserEntity.Id) {
    checkIds([roomId, participantId]);

    const room = await this.gameProvider.setParticipantReady(roomId, participantId);

    const gameIsNotCreatedYet = !room.gameId;
    const isAllParticipantsReady = room.participants.every((p) => p.status === 'ready');

    if (gameIsNotCreatedYet && isAllParticipantsReady) {
      await this.createRoomGame(room.id);
    }
  }

  /// Creation of room game by force without waitng of all players
  async createRoomGame(roomId: RoomEntity.Id) {
    const [room, game] = await this.gameProvider.createRoomGame(roomId);

    const newGame = this.intializeGame(game);
    await this.gameProvider.updateGame(newGame);

    return room;
  }

  private intializeGame(game: Game): Game {
    const newGame = applyGameTransformers(game, [
      new GameEventsTransformer(true),
      new PossessionStateTransformer(),
    ]);

    return newGame;
  }
}
