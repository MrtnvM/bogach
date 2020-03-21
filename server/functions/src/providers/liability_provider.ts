import * as uuid from 'uuid';
import { FirestoreSelector } from './firestore_selector';
import { GameEntity } from '../models/domain/game/game';
import { LiabilityEntity, Liability } from '../models/domain/liability';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';

export class LiabilityProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameEntity.Id
  ) {}

  async getAllLiabilities(userId: UserId): Promise<Liability[]> {
    const selector = this.selector.liabilities(this.gameId, userId);
    const liabilities = await this.firestore.getItems(selector);
    liabilities.forEach(LiabilityEntity.validate);
    return liabilities as Liability[];
  }

  async getLiability(userId: UserId, liabilityId: LiabilityEntity.Id): Promise<Liability> {
    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    const liability = (await this.firestore.getItem(selector)).data();
    LiabilityEntity.validate(liability);
    return liability as Liability;
  }

  async addLiability(userId: UserId, liability: Liability): Promise<Liability> {
    const liabilityId = uuid.v4();
    const newLiability = {
      ...liability,
      id: liabilityId
    };

    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    const createdLiability = await this.firestore.createItem(selector, newLiability);
    LiabilityEntity.validate(createdLiability);
    return createdLiability as Liability;
  }

  async updateLiability(userId: UserId, liability: Liability): Promise<Liability> {
    const liabilityId = liability.id;
    if (!liabilityId) {
      throw 'ERROR: Liability Provider - no liability ID on updating';
    }

    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    const updatedLiability = await this.firestore.updateItem(selector, liability);
    LiabilityEntity.validate(updatedLiability);
    return updatedLiability as Liability;
  }

  async deleteLiability(userId: UserId, liabilityId: LiabilityEntity.Id) {
    const selector = this.selector.liability(this.gameId, userId, liabilityId);
    await this.firestore.removeItem(selector);
  }

  async clearLiabilitys(userId: string) {
    const selector = this.selector.liabilities(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
