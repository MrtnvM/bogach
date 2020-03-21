import * as udid from 'uuid';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { Game, GameEntity } from '../models/domain/game/game';
import { GameEvent, GameEventId } from '../models/domain/game/game_event';

export class GameProvider {
  constructor(private firestore: Firestore, private selector: FirestoreSelector) {}

  async createGame(): Promise<Game> {
    const gameId: GameEntity.Id = udid.v4();
    const game: any = {
      id: gameId,
      currentEvents: []
    };

    const selector = this.selector.game(gameId);
    const createdGame = await this.firestore.createItem(selector, game);

    return createdGame;
  }

  async getAllGames(): Promise<Game[]> {
    const selector = this.selector.games();
    const games = (await this.firestore.getItems(selector)).map(i => i as Game);
    return games;
  }

  async getGameEvent(eventId: GameEventId): Promise<GameEvent> {
    const gameEvent = (await this.firestore.getItem(this.selector.gameEvent(eventId))).data();
    return gameEvent as GameEvent;
  }
}
