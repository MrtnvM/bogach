import { Entity } from '../../core/domain/entity';

export interface Income {
  readonly id?: IncomeEntity.Id;
  readonly name: string;
  readonly value: number;
  readonly type: IncomeEntity.Type;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace IncomeEntity {
  export type Id = string;

  export type Type = 'none' | 'salary' | 'real property' | 'investment' | 'business' | 'other';
  export const TypeValues: Type[] = [
    'none',
    'salary',
    'real property',
    'investment',
    'business',
    'other'
  ];

  export const parse = (data: any): Income => {
    const { id, name, value, type } = data;
    const income = { id, name, value, type };

    validate(income);

    return income;
  };

  export const validate = (income: any) => {
    const entity = Entity.createEntityValidator<Income>(income);

    entity.hasValue('name');
    entity.hasValue('value');
    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);

    entity.check(income => {
      if (income.value < 0) {
        return 'Income cannot be lower than 0';
      }

      return undefined;
    });
  };
}
