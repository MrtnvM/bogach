/// <reference types="@types/node"/>

import * as uuid from 'uuid';
import * as random from 'random';
import { StockEvent } from './stock_event';
import { Game } from '../../models/domain/game/game';
import { randomValueFromRange, valueRange } from '../../core/data/value_range';
import { StockEventCandlesDataSource } from './stock_event_candles_data_source';
import { readJsonFileSync } from '../../utils/json';
import { stocksImagesConfigPath } from '../../scripts/generate_stocks_image_config';

const stockCandlesCache: { [stock: string]: StockEvent.Candle[] } = {};
const stocksImagesCache: { [stock: string]: string } = {};

const getStockCandles = (stockName: string): StockEvent.Candle[] => {
  const cachedStockCandles = stockCandlesCache[stockName];
  if (cachedStockCandles !== undefined) {
    return cachedStockCandles;
  }

  const stockCandles = StockEventCandlesDataSource.getStockCandles(stockName);
  stockCandlesCache[stockName] = stockCandles;

  return stockCandles;
};

const getStockImage = (stockName: string) => {
  const cachedStockImage = stocksImagesCache[stockName];
  if (cachedStockImage) {
    return cachedStockImage;
  }

  const stocksImages = readJsonFileSync(stocksImagesConfigPath);
  Object.keys(stocksImages).forEach((stock) => {
    stocksImagesCache[stock] = stocksImages[stock];
  });

  return stocksImagesCache[stockName];
};

export namespace StockEventGenerator {
  const monthCountInYear = 12;

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

    const { stockEventCandles, currentCandle } = getCandleHistory(
      stockCandles,
      game.state.monthNumber
    );

    const yearAverageStockPrice =
      stockEventCandles.reduce((acc, c) => c.close + acc, 0) / monthCountInYear;
    const currentPrice = random.float(currentCandle.low, currentCandle.high);

    stockEventCandles[stockEventCandles.length - 1].close = currentPrice;

    const maxCount = random.int(9, 14) * 10;

    return generateEvent({
      name: stockName,
      image: getStockImage(stockName),
      currentPrice: valueRange([currentPrice, currentPrice, 0]),
      fairPrice: valueRange([yearAverageStockPrice, yearAverageStockPrice, 0]),
      availableCount: valueRange([maxCount, maxCount, 0]),
      candles: stockEventCandles,
    });
  };

  export const getCandleHistory = (stockCandles: StockEvent.Candle[], monthNumber: number) => {
    /// We should remove 1 because of we start game from month number = 1
    const month = monthNumber - 1;
    const startCandleIndex = month % stockCandles.length;

    const currentCandleIndex = startCandleIndex + monthCountInYear;
    const historyCandlesLength = 30;

    // to avoid array exceed
    const stockCandlesProlonged = stockCandles.concat(stockCandles);

    let candles = stockCandlesProlonged.slice(0, currentCandleIndex + 1);
    candles = candles.slice(-Math.min(historyCandlesLength, candles.length));

    const candleHistoryNotFull = candles.length < historyCandlesLength;
    const isGoingFromBeginingOfCandlesDataAgain = month >= stockCandles.length;

    if (candleHistoryNotFull && isGoingFromBeginingOfCandlesDataAgain) {
      const missingCandlesCount = historyCandlesLength - candles.length;
      const missingCandles = stockCandles.slice(
        -Math.min(missingCandlesCount, stockCandles.length)
      );
      candles = [...missingCandles, ...candles];
    }

    const stockEventCandles = candles;
    const currentCandle = stockCandlesProlonged[currentCandleIndex];

    return { stockEventCandles, currentCandle };
  };

  export const generateEvent = (eventInfo: StockEvent.Info): StockEvent.Event => {
    const { name, image, currentPrice, fairPrice, availableCount, candles } = eventInfo;

    const defaultAvailableCount = random.int(9, 14) * 10;
    const eventRandomAvailableCount = availableCount && randomValueFromRange(availableCount);
    const eventAvailableCount = eventRandomAvailableCount || defaultAvailableCount;

    return {
      id: uuid.v4(),
      name,
      description: '',
      image: image || null,
      type: StockEvent.Type,
      data: {
        currentPrice: randomValueFromRange(currentPrice),
        fairPrice: randomValueFromRange(fairPrice),
        availableCount: eventAvailableCount,
        candles: candles,
      },
    };
  };
}
