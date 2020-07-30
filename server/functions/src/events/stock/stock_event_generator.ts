/// <reference types="@types/node"/>

import * as uuid from 'uuid';
import * as random from 'random';
import { StockEvent } from './stock_event';
import { Game } from '../../models/domain/game/game';
import * as fs from 'fs';
import * as path from 'path';
import { randomValueFromRange, valueRange } from '../../core/data/value_range';

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

export namespace StockEventGenerator {
  export const generate = (game: Game): StockEvent.Event | undefined => {
    const alreadyUsedStocks = game.currentEvents
      .filter((e) => e.type === StockEvent.Type)
      .map((e) => e.name);

    const availableStocks = game.config.stocks.filter((s) =>
      alreadyUsedStocks.every((stock) => stock !== s)
    );

    if (availableStocks.length === 0) {
      return undefined;
    }

    const stockIndex = random.int(0, availableStocks.length - 1);
    const stockName = availableStocks[stockIndex];
    const stockCandles = getStockCandles(stockName);

    const month = game.state.monthNumber;
    const monthCountInYear = 12;
    const startIndex = month % stockCandles.length;

    const yearAverageStockPrice =
      stockCandles
        .slice(startIndex, startIndex + monthCountInYear)
        .reduce((acc, c) => c.Close + acc, 0) / monthCountInYear;

    const currentCandleIndex = startIndex + monthCountInYear;
    const candle = stockCandles[currentCandleIndex];
    const currentPrice = random.float(candle.Low, candle.High);

    const maxCount = random.int(9, 14) * 10;

    return generateEvent({
      name: stockName,
      currentPrice: valueRange([currentPrice, currentPrice, 0]),
      fairPrice: valueRange([yearAverageStockPrice, yearAverageStockPrice, 0]),
      availableCount: valueRange([maxCount, maxCount, 0]),
    });
  };

  export const generateEvent = (eventInfo: StockEvent.Info): StockEvent.Event => {
    const { name, description, currentPrice, fairPrice, availableCount } = eventInfo;

    const defaultAvailableCount = random.int(9, 14) * 10;

    return {
      id: uuid.v4(),
      name: name,
      description: description || '',
      type: StockEvent.Type,
      data: {
        currentPrice: randomValueFromRange(currentPrice),
        fairPrice: randomValueFromRange(fairPrice),
        availableCount:
          (availableCount && randomValueFromRange(availableCount)) || defaultAvailableCount,
      },
    };
  };
}
