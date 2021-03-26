import { Entity } from '../../core/domain/entity';

export interface PurchaseDetails {
  readonly productId: string;
  readonly purchaseId: string;
  readonly verificationData: string;
  readonly source: string;
}

export namespace PurchaseDetailsEntity {
  export const validate = (purchase: any) => {
    const entity = Entity.createEntityValidator<PurchaseDetails>(purchase, 'PurchaseDetails');

    entity.hasStringValue('productId');
    entity.hasStringValue('purchaseId');
  };
}
