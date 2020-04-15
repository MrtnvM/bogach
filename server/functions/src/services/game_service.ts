import { GameEntity, Game } from '../models/domain/game/game';
import { GameProvider } from '../providers/game_provider';
import { DebenturePriceChangedEventGenerator } from '../events/debenture/debenture_price_changed_event_generator';
import { produce } from 'immer';
import { GameEventEntity } from '../models/domain/game/game_event';
import { GameContext } from '../models/domain/game/game_context';
import { PlayerActionHandler } from '../core/domain/player_action_handler';
import { DebenturePriceChangedHandler } from '../events/debenture/debenture_price_changed_handler';

export class GameService {
  constructor(private gameProvider: GameProvider) {
    this.handlers.forEach((handler) => {
      this.handlerMap[handler.gameEventType] = handler;
    });
  }

  private handlers: PlayerActionHandler[] = [new DebenturePriceChangedHandler(this.gameProvider)];
  private handlerMap: { [type: string]: PlayerActionHandler } = {};

  async generateGameEvents(gameId: GameEntity.Id): Promise<Game> {
    if (!gameId) throw new Error('Missing Game ID');

    const game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const gameEvents = [
      DebenturePriceChangedEventGenerator.generate(),
      DebenturePriceChangedEventGenerator.generate(),
      DebenturePriceChangedEventGenerator.generate(),
      DebenturePriceChangedEventGenerator.generate(),
      DebenturePriceChangedEventGenerator.generate(),
    ];

    const gameWithNewEvents = produce(game, (draft) => {
      draft.currentEvents = gameEvents;
    });

    const updatedGame = await this.gameProvider.updateGame(gameWithNewEvents);
    return updatedGame;
  }

  async handlePlayerAction(eventId: GameEventEntity.Id, action: any, context: GameContext) {
    const { gameId } = context;

    const game = await this.gameProvider.getGame(gameId);
    if (!game) throw new Error('No game with ID: ' + gameId);

    const event = game.currentEvents.find((e) => e.id === eventId);
    if (!event) throw new Error('No game event with ID: ' + eventId);

    const handler = this.handlerMap[event.type];
    if (!handler) throw new Error('Event handler not found for event with ID: ' + eventId);

    await handler.validate(event, action);
    await handler.handle(event, action, context);
  }
}
