import { Entity } from '../../core/domain/entity';
import { Expense } from './expense';

export interface Liability {
  readonly id?: LiabilityEntity.Id;
  readonly name: string;
  readonly type: LiabilityEntity.Type;
  readonly monthlyPayment: number;
  readonly value: number;
}

export namespace LiabilityEntity {
  export type Id = string;

  export type Type = 'mortgage' | 'business_credit' | 'other';
  export const TypeValues: Type[] = ['mortgage', 'business_credit', 'other'];

  export const validate = (liability: any) => {
    const entity = Entity.createEntityValidator<Liability>(liability, 'Liability');

    entity.hasValue('name');
    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);
    entity.hasNumberValue('monthlyPayment');
    entity.hasNumberValue('value');
  };

  export const getExpense = (liability: Liability): Expense => {
    return {
      id: liability.id || null,
      name: liability.name,
      value: liability.monthlyPayment,
    };
  };

  const filterAssets = <T extends Liability>(liabilities: Liability[], type: Type) => {
    return (liabilities?.filter((a) => a.type === type) as T[]) ?? [];
  };

  export const getBusinessCredits = (liabilities: Liability[]) => {
    return filterAssets<Liability>(liabilities, 'business_credit');
  };
}
