import { Entity } from '../../core/domain/entity';

export interface Expense {
  readonly id?: ExpenseEntity.Id | null;
  readonly name: string;
  readonly value: number;
}

export namespace ExpenseEntity {
  export type Id = string;

  export const parse = (data: any): Expense => {
    const { id, name, value, type } = data;
    const expense = { id, name, value, type };

    validate(expense);

    return expense;
  };

  export const validate = (expense: any) => {
    const entity = Entity.createEntityValidator<Expense>(expense, 'Expense');

    entity.hasValue('name');
    entity.hasValue('value');

    entity.check((e) => {
      if (e.value <= 0) {
        return 'Expense cannot be equal or lower than 0';
      }

      return undefined;
    });
  };
}
