import { Entity } from '../../core/domain/entity';

export interface Liability {
  readonly id?: LiabilityEntity.Id;
  readonly name: string;
  readonly type: LiabilityEntity.Type;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace LiabilityEntity {
  export type Id = string;

  export type Type = 'mortgage' | 'business_credit' | 'other';
  export const TypeValues: Type[] = ['mortgage', 'business_credit', 'other'];

  export const parse = (data: any): Liability => {
    const { id, name, type } = data;
    const liability = { id, name, type };

    validate(liability);

    return liability;
  };

  export const validate = (liability: any) => {
    const entity = Entity.createEntityValidator<Liability>(liability);

    entity.hasValue('name');
    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);
  };

  export const getExpense = (liability: Liability) => {
    return undefined;
  };
}
