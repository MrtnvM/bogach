import { AssetEntity } from '../models/domain/asset';
import { LiabilityEntity } from '../models/domain/liability';
import { Possessions } from '../models/domain/possessions';
import { PossessionState, PossessionStateEntity } from '../models/domain/possession_state';
import { Game } from '../models/domain/game/game';
import { ParticipantGameState } from '../models/domain/game/participant_game_state';

export class PossessionStateGenerator {
  generatePossessionState(possessions: Possessions): PossessionState {
    const incomes = possessions.incomes.slice();
    const expenses = possessions.expenses.slice();
    const assets = possessions.assets.slice();
    const liabilities = possessions.liabilities.slice();

    assets.forEach((asset) => {
      const income = AssetEntity.getIncome(asset);
      if (income) incomes.push(income);

      const expense = AssetEntity.getExpense(asset);
      if (expense) expenses.push(expense);
    });

    liabilities.forEach((liability) => {
      const expense = LiabilityEntity.getExpense(liability);
      if (expense) expenses.push(expense);
    });

    const newPossessionState: PossessionState = { incomes, expenses, assets, liabilities };
    return PossessionStateEntity.normalize(newPossessionState);
  }

  generateParticipantsPossessionState(game: Game): ParticipantGameState<Possessions> {
    const newPossessionState: ParticipantGameState<Possessions> = {};

    game.participants.forEach((participantId) => {
      const possessionState = this.generatePossessionState(game.possessions[participantId]);
      newPossessionState[participantId] = possessionState;
    });

    return newPossessionState;
  }
}
