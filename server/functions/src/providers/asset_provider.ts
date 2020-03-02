import * as uuid from 'uuid';
import { FirestoreSelector } from './firestore_selector';
import { GameId } from '../models/domain/game';
import { AssetEntity, Asset } from '../models/domain/asset';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';

export class AssetProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameId
  ) {}

  async getAllAssets(userId: UserId) {
    const selector = this.selector.assets(this.gameId, userId);
    const assets = await this.firestore.getItems(selector);
    return assets;
  }

  async getAsset(userId: UserId, assetId: AssetEntity.Id) {
    const selector = this.selector.asset(this.gameId, userId, assetId);
    const asset = await this.firestore.getItem(selector);
    return asset;
  }

  async addAsset(userId: UserId, asset: Asset) {
    const assetId = uuid.v4();
    const newAsset = {
      ...asset,
      id: assetId
    };

    const selector = this.selector.asset(this.gameId, userId, assetId);
    const createdAsset = await this.firestore.createItem(selector, newAsset);
    return createdAsset;
  }

  async updateAsset(userId: UserId, asset: Asset) {
    const assetId = asset.id;
    if (!assetId) {
      throw 'ERROR: Asset Provider - no asset ID on updating';
    }

    const selector = this.selector.asset(this.gameId, userId, assetId);
    const updatedAsset = await this.firestore.updateItem(selector, asset);
    return updatedAsset;
  }

  async deleteAsset(userId: UserId, assetId: AssetEntity.Id) {
    const selector = this.selector.asset(this.gameId, userId, assetId);
    this.firestore.removeItem(selector);
  }

  async clearAssets(userId: string) {
    const selector = this.selector.assets(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
