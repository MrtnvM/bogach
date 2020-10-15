import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { PurchaseDetailsEntity } from '../models/purchases/purchase_details';
import { FirestoreSelector } from '../providers/firestore_selector';
import { UserProvider } from '../providers/user_provider';
import { PurchaseService } from '../services/purchase/purchase_service';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const userProvider = new UserProvider(firestore, selector);
  const purchaseService = new PurchaseService(userProvider);

  const updatePurchases = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const userId = apiRequest.jsonField('userId');
    const purchases = apiRequest.jsonField('purchases');

    if (!Array.isArray(purchases)) {
      throw new Error('Purchases should be an array');
    }

    purchases.forEach(PurchaseDetailsEntity.validate);

    const updatePurchasesOperation = purchaseService.updatePurchases(userId, purchases);
    await send(updatePurchasesOperation, response);
  });

  const send = <T>(data: Promise<T>, response: functions.Response) => {
    return data
      .then((result) => response.status(200).send(result))
      .catch((error) => {
        if (error['type'] === 'domain') {
          const json = JSON.stringify(error);
          response.status(422).send(json);
          return;
        }

        const errorMessage = error['message'] ? error.message : error;
        console.error('ERROR: ' + JSON.stringify(error));
        console.error('ERROR MESSAGE: ' + errorMessage);
        response.status(422).send(errorMessage);
      });
  };

  return {
    updatePurchases,
  };
};
