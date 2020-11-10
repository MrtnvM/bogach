import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game, GameEntity } from '../../models/domain/game/game';
import { LiabilityEntity } from '../../models/domain/liability';
import { AssetEntity } from '../../models/domain/asset';
import { PossessionState } from '../../models/domain/possession_state';
import { Possessions } from '../../models/domain/possessions';

export class PossessionStateTransformer extends GameTransformer {
  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const participants = this.generatePossessionStateForParticipants(game);

    return produce(game, (draft) => {
      draft.participants = participants;
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

  generatePossessionStateForParticipants(game: Game): { [userId: string]: GameEntity.Participant } {
    const newParticipants: { [userId: string]: GameEntity.Participant } = {};

    game.participantsIds.forEach((participantId) => {
      const participant = game.participants[participantId];
      const possessionState = this.generatePossessionState(participant.possessions);
      const newParticipant = produce(participant, (draft) => {
        draft.possessionState = possessionState;
      });

      newParticipants[participantId] = newParticipant;
    });

    return newParticipants;
  }
}
