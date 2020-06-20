/// <reference types="@types/node"/>

import { GameTransformer } from '../../game_transformer';
import { Game } from '../../../../models/domain/game/game';
import * as fs from 'fs';
import * as path from 'path';
import * as random from 'random';
import { produce } from 'immer';

export class StocksInitializerGameTransformer extends GameTransformer {
  apply(game: Game): Game {
    const isGameCompleted = game.state.gameStatus === 'game_over';
    const isStocksConfigured = game.config.stocks.length !== 0;

    if (isGameCompleted || isStocksConfigured) {
      return game;
    }

    const stocksDataPath = path.join(
      __dirname,
      '..',
      '..',
      '..',
      '..',
      '..',
      'data',
      'stocks_history'
    );
    const files = fs.readdirSync(stocksDataPath);

    const stocksCountInGame = random.int(4, 7);
    const selectedIndexes = {};
    let selectedIndexCount = 0;

    while (selectedIndexCount < stocksCountInGame) {
      const stockIndex = random.int(0, files.length - 1);

      if (!selectedIndexes[stockIndex]) {
        selectedIndexes[stockIndex] = stockIndex;
        selectedIndexCount++;
      }
    }

    const selectedStocks = Object.values(selectedIndexes)
      .map((s) => files[s as number])
      .map((s) => s.replace('.json', ''));

    return produce(game, (draft) => {
      draft.config.stocks = selectedStocks;
    });
  }
}
