import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { AssetEntity } from '../models/domain/asset';
import { AssetProvider } from '../providers/asset_provider';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const create = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const context = apiRequest.getContext();
    const asset = apiRequest.parseEntity('asset', AssetEntity.parse);

    const expenseProvider = new AssetProvider(firestore, selector, context.gameId);
    const createdAsset = await expenseProvider.addAsset(context.userId, asset);

    response.status(200).send(createdAsset);
  });

  const getAll = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);
    const context = apiRequest.getContext();

    const assetProvider = new AssetProvider(firestore, selector, context.gameId);
    const assets = await assetProvider.getAllAssets(context.userId);

    response.status(200).send(assets);
  });

  return { create, getAll };
};
