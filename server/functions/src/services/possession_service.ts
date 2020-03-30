import { AssetEntity } from '../models/domain/asset';
import { LiabilityEntity } from '../models/domain/liability';
import { Possessions } from '../models/domain/possessions';
import { PossessionState, PossessionStateEntity } from '../models/domain/possession_state';
import { GameProvider } from '../providers/game_provider';
import { GameContext } from '../models/domain/game/game_context';
import { Game } from '../models/domain/game/game';

export class PossessionService {
  constructor(private gameProvider: GameProvider) {}

  async generatePossessionState(possessions: Possessions) {
    const incomes = possessions.incomes.slice();
    const expenses = possessions.expenses.slice();
    const assets = possessions.assets.slice();
    const liabilities = possessions.liabilities.slice();

    assets.forEach(asset => {
      const income = AssetEntity.getIncome(asset);
      if (income) incomes.push(income);

      const expense = AssetEntity.getExpense(asset);
      if (expense) expenses.push(expense);
    });

    liabilities.forEach(liability => {
      const expense = LiabilityEntity.getExpense(liability);
      if (expense) expenses.push(expense);
    });

    const newPossessionState: PossessionState = { incomes, expenses, assets, liabilities };
    return PossessionStateEntity.normalize(newPossessionState);
  }

  async updatePossessionState(context: GameContext): Promise<PossessionState> {
    const { gameId, userId } = context;
    const game = await this.gameProvider.getGame(gameId);
    const possessions = game.possessions[userId];

    const newPossessionState = await this.generatePossessionState(possessions);
    const updatedGame: Game = {
      ...game,
      possessionState: { ...game.possessionState, [userId]: newPossessionState }
    };

    await this.gameProvider.updateGame(updatedGame);

    return newPossessionState;
  }
}
