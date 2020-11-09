import { Entity } from '../../../core/domain/entity';
import { UserEntity } from '../user/user';
import { Game } from './game';

export interface GameTarget {
  readonly type: GameTargetEntity.Type;
  readonly value: number;
}

export namespace GameTargetEntity {
  export type Type = 'passive_income' | 'cash';
  const TypeValues = ['passive_income', 'cash'];

  export const validate = (game: any) => {
    const entity = Entity.createEntityValidator<GameTarget>(game, 'Game Target');

    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);
    entity.hasValue('value');
  };

  export const calculateProgress = (game: Game, userId: UserEntity.Id): number => {
    switch (game.target.type) {
      case 'passive_income':
        const incomes = game.participants[userId].possessions.incomes;
        const passiveIncomes = incomes.filter((i) => i.type !== 'salary');
        const passiveIncomeValue = passiveIncomes.reduce((prev, curr) => prev + curr.value, 0);
        const passiveIncomeProgress = passiveIncomeValue / game.target.value;
        return passiveIncomeProgress;

      case 'cash':
        const cash = game.participants[userId].account.cash;
        const cashProgress = cash / game.target.value;
        return cashProgress;
    }
  };
}
