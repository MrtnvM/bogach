import { Game, GameEntity } from '../../models/domain/game/game';
import {
  applyGameTransformers,
  StocksInitializerGameTransformer,
  DebentureInitializerGameTransformer,
} from '../../transformers/game_transformers';

export namespace GameFixture {
  export const createGame = (game: Partial<Game> | undefined = undefined): Game => {
    const participants = game?.participants ?? {};
    const participantsIds = Object.keys(participants);

    let newGame: Game = {
      id: game?.id || 'game1',
      name: game?.name || 'Game 1',
      type: game?.type || 'singleplayer',
      participants,
      participantsIds,
      state: game?.state || {
        gameStatus: 'players_move',
        monthNumber: 1,
        moveStartDateInUTC: new Date().toISOString(),
        winners: [],
      },
      target: game?.target || { type: 'cash', value: 1_000_000 },
      currentEvents: game?.currentEvents || [],
      history: game?.history || { months: [] },
      config: game?.config || {
        stocks: [],
        debentures: [],
        initialCash: 1_000,
        gameTemplateId: '1',
      },
    };

    newGame = applyGameTransformers(newGame, [
      new StocksInitializerGameTransformer(),
      new DebentureInitializerGameTransformer(),
    ]);

    GameEntity.validate(newGame);
    return newGame;
  };
}
