import { Entity } from '../../core/domain/entity';

export interface Expense {
  readonly id?: ExpenseEntity.Id;
  readonly name: string;
  readonly value: number;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace ExpenseEntity {
  export type Id = string;

  export const parse = (data: any): Expense => {
    const { id, name, value } = data;
    const expense = { id, name, value };

    validate(expense);

    return expense;
  };

  export const validate = (expense: any) => {
    const entity = Entity.createEntityValidator<Expense>(expense);

    entity.hasValue('name');
    entity.hasValue('value');
  };
}
