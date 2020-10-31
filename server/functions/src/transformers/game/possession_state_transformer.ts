import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { LiabilityEntity } from '../../models/domain/liability';
import { AssetEntity } from '../../models/domain/asset';
import { PossessionState } from '../../models/domain/possession_state';
import { ParticipantGameState } from '../../models/domain/game/participant_game_state';
import { Possessions } from '../../models/domain/possessions';

export class PossessionStateTransformer extends GameTransformer {
  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const possessionState = this.generateParticipantsPossessionState(game);

    return produce(game, (draft) => {
      draft.possessionState = possessionState;
    });
  }

  generatePossessionState(possessions: Possessions): PossessionState {
    const incomes = (possessions.incomes || []).slice();
    const expenses = (possessions.expenses || []).slice();
    const assets = (possessions.assets || []).slice();
    const liabilities = (possessions.liabilities || []).slice();

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
    return newPossessionState;
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
