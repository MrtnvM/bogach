import { FirestoreSelector } from './firestore_selector';
import { GameId } from '../models/domain/game';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';
import { PossessionState } from '../models/domain/possession_state';

export class PossessionStateProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameId
  ) {}

  async getPossessionState(userId: UserId): Promise<PossessionState> {
    const selector = this.selector.possessionState(this.gameId, userId);
    const possessionState = (await this.firestore.getItem(selector)).data();
    return possessionState as PossessionState;
  }

  async updatePossessionState(userId: UserId, state: PossessionState): Promise<PossessionState> {
    const selector = this.selector.possessionState(this.gameId, userId);
    let possessionState;

    if ((await selector.get()).exists) {
      possessionState = await this.firestore.updateItem(selector, state);
    } else {
      possessionState = await this.firestore.createItem(selector, state);
    }

    return possessionState as PossessionState;
  }

  async clearState(userId: string): Promise<void> {
    const selector = this.selector.possessionState(this.gameId, userId);
    await this.firestore.updateItem(selector, {});
  }
}
