/// <reference types="@types/jest"/>

import path = require('path');
import { GameFixture } from '../../core/fixtures/game_fixture';
import { StockEventCandlesDataSource } from './stock_event_candles_data_source';
import { StockEventGenerator } from './stock_event_generator';

describe('Stock event generator', () => {
  test('Successfully generate stock event', async () => {
    const game = GameFixture.createGame({
      state: {
        gameStatus: 'players_move',
        monthNumber: 47,
        moveStartDateInUTC: new Date().toISOString(),
        winners: [],
      },
    });

    const event = StockEventGenerator.generate(game);
    expect(event !== undefined);
  });

  test('Generation of stock candles history for 1 month', () => {
    const yandexCandles = getYandexCandles();
    const { stockEventCandles, currentCandle } = StockEventGenerator.getCandleHistory(
      yandexCandles,
      1
    );

    expect(stockEventCandles.length).toEqual(13);

    expect(stockEventCandles[0]).toStrictEqual({
      open: 1401.5,
      close: 1442,
      high: 1543,
      low: 1335,
      time: '2016-07-01T07:00:00.0000000Z',
    });

    expect(stockEventCandles[stockEventCandles.length - 1]).toStrictEqual({
      open: 1553,
      close: 1743,
      high: 2039.5,
      low: 1538.5,
      time: '2017-07-01T07:00:00.0000000Z',
    });

    expect(currentCandle).toStrictEqual({
      open: 1553,
      close: 1743,
      high: 2039.5,
      low: 1538.5,
      time: '2017-07-01T07:00:00.0000000Z',
    });
  });

  test('Generation of stock candles history for last month in stock data', () => {
    const yandexCandles = getYandexCandles();
    const lastMonthNumber = yandexCandles.length;

    const { stockEventCandles, currentCandle } = StockEventGenerator.getCandleHistory(
      yandexCandles,
      lastMonthNumber
    );

    expect(stockEventCandles.length).toEqual(30);

    expect(currentCandle).toStrictEqual({
      open: 1485.5,
      close: 1536,
      high: 1643,
      low: 1430,
      time: '2017-06-01T07:00:00.0000000Z',
    });

    expect(stockEventCandles[stockEventCandles.length - 1]).toStrictEqual({
      open: 1485.5,
      close: 1536,
      high: 1643,
      low: 1430,
      time: '2017-06-01T07:00:00.0000000Z',
    });

    expect(stockEventCandles[0]).toStrictEqual({
      open: 1918.5,
      close: 2212,
      high: 2214.5,
      low: 1857,
      time: '2019-01-01T07:00:00.0000000Z',
    });
  });

  test('Generation of stock candles history for when stock data array exceded', () => {
    const yandexCandles = getYandexCandles();
    const lastMonthNumber = yandexCandles.length + 1;

    const { stockEventCandles, currentCandle } = StockEventGenerator.getCandleHistory(
      yandexCandles,
      lastMonthNumber
    );

    expect(stockEventCandles.length).toEqual(30);

    expect(stockEventCandles[0]).toStrictEqual({
      open: 2200.2,
      close: 2208,
      high: 2335,
      low: 2090.4,
      time: '2019-02-01T07:00:00.0000000Z',
    });

    expect(stockEventCandles[stockEventCandles.length - 1]).toStrictEqual({
      open: 1553,
      close: 1743,
      high: 2039.5,
      low: 1538.5,
      time: '2017-07-01T07:00:00.0000000Z',
    });

    expect(currentCandle).toStrictEqual({
      open: 1553,
      close: 1743,
      high: 2039.5,
      low: 1538.5,
      time: '2017-07-01T07:00:00.0000000Z',
    });
  });
});

const getYandexCandles = () => {
  const stockDataFile = 'Yandex.json';
  const stockDataPath = path.join(__dirname, stockDataFile);
  const candles = StockEventCandlesDataSource.getStockCandlesFromFile(stockDataPath);
  return candles;
};
