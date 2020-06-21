/// <reference types="@types/node"/>

import * as uuid from 'uuid';
import * as random from 'random';
import { StockPriceChangedEvent } from './stock_price_changed_event';
import { Game } from '../../models/domain/game/game';
import * as fs from 'fs';
import * as path from 'path';

type Candle = {
  High: number;
  Low: number;
  Open: number;
  Close: number;
};

const stockCandlesCache: { [stock: string]: Candle[] } = {};

const getStockCandles = (stockName: string): Candle[] => {
  const cachedStockCandles = stockCandlesCache[stockName];
  if (cachedStockCandles !== undefined) {
    return cachedStockCandles;
  }

  const stockDataFile = stockName + '.json';
  const stockDataPath = path.join(
    __dirname,
    '..',
    '..',
    '..',
    'data',
    'stocks_history',
    stockDataFile
  );

  const rawData = fs.readFileSync(stockDataPath, 'utf8');
  const stockCandles = JSON.parse(rawData) as Candle[];
  stockCandlesCache[stockName] = stockCandles;

  return stockCandles;
};

export namespace StockPriceChangedEventGenerator {
  export const generate = (game: Game): StockPriceChangedEvent.Event => {
    const alreadyUsedStocks = game.currentEvents
      .filter((e) => e.type === StockPriceChangedEvent.Type)
      .map((e) => e.name);

    const availableStocks = game.config.stocks.filter((s) =>
      alreadyUsedStocks.every((stock) => stock !== s)
    );

    const stockIndex = random.int(0, availableStocks.length - 1);
    const stockName = availableStocks[stockIndex];
    const stockCandles = getStockCandles(stockName);

    const month = game.state.monthNumber;
    const monthCountInYear = 12;
    const startIndex = month % stockCandles.length;

    const yearAverageStockPrice =
      stockCandles
        .slice(startIndex, startIndex + monthCountInYear)
        .reduce((acc, candle) => candle.Close + acc, 0) / monthCountInYear;

    const currentCandleIndex = startIndex + monthCountInYear;
    const candle = stockCandles[currentCandleIndex];
    const currentPrice = random.float(candle.Low, candle.High);

    const maxCount = random.int(9, 14) * 10;

    return {
      id: uuid.v4(),
      name: stockName,
      description: '',
      type: StockPriceChangedEvent.Type,
      data: {
        currentPrice,
        fairPrice: yearAverageStockPrice,
        availableCount: maxCount,
      },
    };
  };
}
