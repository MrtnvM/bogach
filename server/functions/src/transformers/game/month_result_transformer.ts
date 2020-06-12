import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { GameTransformer } from './game_transformer';
import { AssetEntity } from '../../models/domain/asset';

export class MonthResultTransformer extends GameTransformer {
  constructor(private month: number | undefined = undefined) {
    super();
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    return produce(game, (draft) => {
      draft.participants.forEach((participantId) => {
        const participantProgress = game.state.participantsProgress[participantId];
        const isMonthResult = participantProgress.status === 'month_result';

        if (!isMonthResult && this.month === undefined) {
          return;
        }

        const { monthResults, currentMonthForParticipant } = participantProgress;
        const resultMonth = this.month !== undefined ? this.month : currentMonthForParticipant;
        const resultAlreadyExists = monthResults[resultMonth] !== undefined;

        if (resultAlreadyExists) {
          return;
        }

        const possessionState = game.possessionState[participantId];
        const { incomes, expenses, assets, liabilities } = possessionState;

        const totalIncome = incomes.reduce((total, income) => total + income.value, 0);
        const totalExpense = expenses.reduce((total, expense) => total + expense.value, 0);

        const totalAssets = assets
          .map(AssetEntity.getAssetValue)
          .reduce((total, assetValue) => total + assetValue, 0);

        const totalLiabilities = liabilities.reduce(
          (total, liability) => total + liability.value,
          0
        );

        draft.state.participantsProgress[participantId].monthResults[resultMonth] = {
          cash: game.accounts[participantId].cash,
          totalIncome,
          totalExpense,
          totalAssets,
          totalLiabilities,
        };
      });
    });
  }
}
