/// <reference types="@types/node"/>

import { StockEvent } from './stock_event';
import * as fs from 'fs';
import * as path from 'path';

type SerializableCandle = {
  h: number;
  l: number;
  o: number;
  c: number;
  time: Date;
};

export namespace StockEventCandlesDataSource {
  export const getStockCandles = (stockName: string): StockEvent.Candle[] => {
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

    return getStockCandlesFromFile(stockDataPath);
  };

  export const getStockCandlesFromFile = (stockDataPath: string): StockEvent.Candle[] => {
    const rawData = fs.readFileSync(stockDataPath, 'utf8');
    const serializableStockCandles = JSON.parse(rawData) as SerializableCandle[];
    const stockCandles = mapCandlesFromSerializable(serializableStockCandles);

    return stockCandles;
  };

  const mapCandlesFromSerializable = (
    serializableCandles: SerializableCandle[]
  ): StockEvent.Candle[] => {
    return serializableCandles.map((serializableCandle) => {
      const candle: StockEvent.Candle = {
        low: serializableCandle.l ?? serializableCandle['Low'],
        high: serializableCandle.h ?? serializableCandle['High'],
        open: serializableCandle.o ?? serializableCandle['Open'],
        close: serializableCandle.c ?? serializableCandle['Close'],
        time: serializableCandle.time ?? serializableCandle['Time'],
      };

      return candle;
    });
  };
}
