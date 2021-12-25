import * as express from 'express';

import { APIRequest } from '../core/api/request_data';
import { DAOs } from '../dao/daos';
import { PurchaseDetailsEntity } from '../models/purchases/purchase_details';
import { UserProvider } from '../providers/user_provider';
import { PurchaseService } from '../services/purchase/purchase_service';
import { sendResponse } from '../core/api/send_response';

export const initialize = (daos: DAOs, app: express.Express) => {
  const userProvider = new UserProvider(daos.user);
  const purchaseService = new PurchaseService(userProvider);

  app.post('/updatePurchases', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const userId = apiRequest.jsonField('userId');
    const purchases = apiRequest.jsonField('purchases');

    if (!Array.isArray(purchases)) {
      throw new Error('Purchases should be an array');
    }

    purchases.forEach(PurchaseDetailsEntity.validate);

    const updatePurchasesOperation = purchaseService.updatePurchases(userId, purchases);
    await sendResponse(updatePurchasesOperation, response);
  });
};
