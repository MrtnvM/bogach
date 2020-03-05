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

  async getAllAssets(userId: UserId): Promise<Asset[]> {
    const selector = this.selector.assets(this.gameId, userId);
    const assets = await this.firestore.getItems(selector);
    assets.forEach(AssetEntity.validate);
    return assets as Asset[];
  }

  async getAsset(userId: UserId, assetId: AssetEntity.Id): Promise<Asset> {
    const selector = this.selector.asset(this.gameId, userId, assetId);
    const asset = (await this.firestore.getItem(selector)).data();
    AssetEntity.validate(asset);
    return asset as Asset;
  }

  async addAsset(userId: UserId, asset: Asset): Promise<Asset> {
    const assetId = uuid.v4();
    const newAsset = {
      ...asset,
      id: assetId
    };

    const selector = this.selector.asset(this.gameId, userId, assetId);
    const createdAsset = await this.firestore.createItem(selector, newAsset);
    AssetEntity.validate(createdAsset);
    return createdAsset as Asset;
  }

  async updateAsset(userId: UserId, asset: Asset): Promise<Asset> {
    const assetId = asset.id;
    if (!assetId) {
      throw 'ERROR: Asset Provider - no asset ID on updating';
    }

    const selector = this.selector.asset(this.gameId, userId, assetId);
    const updatedAsset = await this.firestore.updateItem(selector, asset);
    AssetEntity.validate(updatedAsset);
    return updatedAsset as Asset;
  }

  async deleteAsset(userId: UserId, assetId: AssetEntity.Id) {
    const selector = this.selector.asset(this.gameId, userId, assetId);
    await this.firestore.removeItem(selector);
  }

  async clearAssets(userId: string) {
    const selector = this.selector.assets(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
