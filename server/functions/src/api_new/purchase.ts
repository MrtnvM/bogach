import * as express from 'express';

import { APIRequest } from '../core/api/request_data';
import { DAOs } from '../dao/daos';
import { PurchaseDetailsEntity } from '../models/purchases/purchase_details';
import { UserProvider } from '../providers/user_provider';
import { PurchaseService } from '../services/purchase/purchase_service';

export const initialize = (daos: DAOs, app: express.Express) => {
  const userProvider = new UserProvider(daos.user);
  const purchaseService = new PurchaseService(userProvider);

  app.post(
    '/updatePurchases',
    APIRequest.handle(async (apiRequest) => {
      const userId = apiRequest.jsonField('userId');
      const purchases = apiRequest.jsonField('purchases');

      if (!Array.isArray(purchases)) {
        throw new Error('Purchases should be an array');
      }

      purchases.forEach(PurchaseDetailsEntity.validate);

      const purchaseProfile = await purchaseService.updatePurchases(userId, purchases);
      return purchaseProfile;
    })
  );
};
