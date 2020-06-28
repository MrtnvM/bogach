import { Entity } from '../../core/domain/entity';

export interface Income {
  readonly id?: IncomeEntity.Id | null;
  readonly name: string;
  readonly value: number;
  readonly type: IncomeEntity.Type;
}

export namespace IncomeEntity {
  export type Id = string;

  export type Type = 'salary' | 'realty' | 'investment' | 'business' | 'other';
  export const TypeValues: Type[] = ['salary', 'realty', 'investment', 'business', 'other'];

  export const validate = (income: any) => {
    const entity = Entity.createEntityValidator<Income>(income, 'Income');

    entity.hasValue('name');
    entity.hasValue('value');
    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);

    entity.check((i) => {
      if (i.value < 0) {
        return 'Income cannot be lower than 0';
      }

      return undefined;
    });
  };
}
