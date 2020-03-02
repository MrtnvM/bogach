import * as uuid from 'uuid';
import { FirestoreSelector } from './firestore_selector';
import { GameId } from '../models/domain/game';
import { LiabilityEntity, Liability } from '../models/domain/liability';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';

export class LiabilityProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameId
  ) {}

  async getAllLiabilitys(userId: UserId) {
    const selector = this.selector.liabilities(this.gameId, userId);
    const liabilitys = await this.firestore.getItems(selector);
    return liabilitys;
  }

  async getLiability(userId: UserId, liabilityId: LiabilityEntity.Id) {
    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    const liability = await this.firestore.getItem(selector);
    return liability;
  }

  async addLiability(userId: UserId, liability: Liability) {
    const liabilityId = uuid.v4();
    const newLiability = {
      ...liability,
      id: liabilityId
    };

    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    const createdLiability = await this.firestore.createItem(selector, newLiability);
    return createdLiability;
  }

  async updateLiability(userId: UserId, liability: Liability) {
    const liabilityId = liability.id;
    if (!liabilityId) {
      throw 'ERROR: Liability Provider - no liability ID on updating';
    }

    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    const updatedLiability = await this.firestore.updateItem(selector, liability);
    return updatedLiability;
  }

  async deleteLiability(userId: UserId, liabilityId: LiabilityEntity.Id) {
    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    this.firestore.removeItem(selector);
  }

  async clearLiabilitys(userId: string) {
    const selector = this.selector.liabilities(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
