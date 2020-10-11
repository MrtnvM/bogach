import { Game, GameEntity } from '../../models/domain/game/game';
import { createParticipantsGameState } from '../../models/domain/game/participant_game_state';
import { PossessionsEntity } from '../../models/domain/possessions';
import { PossessionStateEntity } from '../../models/domain/possession_state';
import { AssetEntity } from '../../models/domain/asset';
import {
  applyGameTransformers,
  StocksInitializerGameTransformer,
  DebentureInitializerGameTransformer,
} from '../../transformers/game_transformers';

export namespace GameFixture {
  export const createGame = (game: Partial<Game> | undefined = undefined): Game => {
    const participants = game?.participants || [];
    const defaultInitialCash = 20_000;

    const accounts =
      game?.accounts ||
      createParticipantsGameState(participants, {
        cashFlow: 10_000,
        cash: defaultInitialCash,
        credit: 0,
      });

    const possessionState =
      game?.possessionState ||
      createParticipantsGameState(participants, PossessionStateEntity.createEmpty());

    const participantsProgress: { [userId: string]: GameEntity.ParticipantProgress } = {};
    participants.forEach((id) => {
      const { incomes, expenses, assets, liabilities } = possessionState[id];

      const totalIncome = incomes.reduce((total, income) => total + income.value, 0);
      const totalExpense = expenses.reduce((total, expense) => total + expense.value, 0);

      const totalAssets = assets
        .map(AssetEntity.getAssetValue)
        .reduce((total, assetValue) => total + assetValue, 0);

      const totalLiabilities = liabilities.reduce((total, liability) => total + liability.value, 0);

      const monthResult: GameEntity.MonthResult = {
        cash: accounts[id].cash,
        totalIncome,
        totalExpense,
        totalAssets,
        totalLiabilities,
      };

      participantsProgress[id] = {
        currentEventIndex: 0,
        currentMonthForParticipant: 1,
        status: 'player_move',
        monthResults: { 0: monthResult },
        progress: 0,
      };
    });

    let newGame: Game = {
      id: game?.id || 'game1',
      name: game?.name || 'Game 1',
      type: game?.type || 'singleplayer',
      participants: game?.participants || [],
      state: game?.state || {
        gameStatus: 'players_move',
        monthNumber: 1,
        participantsProgress,
        winners: {},
      },
      possessions:
        game?.possessions ||
        createParticipantsGameState(participants, PossessionsEntity.createEmpty()),
      possessionState,
      accounts,
      target: game?.target || { type: 'cash', value: 1_000_000 },
      currentEvents: game?.currentEvents || [],
      history: game?.history || { months: [] },
      config: game?.config || { stocks: [], debentures: [], initialCash: 1_000 },
    };

    newGame = applyGameTransformers(newGame, [
      new StocksInitializerGameTransformer(),
      new DebentureInitializerGameTransformer(),
    ]);

    GameEntity.validate(newGame);
    return newGame;
  };
}
