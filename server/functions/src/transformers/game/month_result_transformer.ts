import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { GameTransformer } from './game_transformer';
import { AssetEntity } from '../../models/domain/asset';

export class MonthResultTransformer extends GameTransformer {
  constructor(private month: number | undefined = undefined) {
    super();
  }

  transformerContext() {
    return { name: 'MonthResultTransformer', month: this.month };
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    return produce(game, (draft) => {
      draft.participantsIds.forEach((participantId) => {
        const participant = draft.participants[participantId];

        const participantProgress = participant.progress;
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

        const possessionState = participant.possessionState;
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

        participant.progress.monthResults[resultMonth] = {
          cash: game.participants[participantId].account.cash,
          totalIncome,
          totalExpense,
          totalAssets,
          totalLiabilities,
        };
      });
    });
  }
}
