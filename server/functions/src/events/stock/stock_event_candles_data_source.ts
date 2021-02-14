/// <reference types="@types/node"/>

import { StockEvent } from './stock_event';
import * as fs from 'fs';
import * as path from 'path';

type SerializableCandle = {
  High: number;
  Low: number;
  Open: number;
  Close: number;
  Time: Date;
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
        low: serializableCandle.Low,
        high: serializableCandle.High,
        open: serializableCandle.Open,
        close: serializableCandle.Close,
        time: serializableCandle.Time,
      };
  
      return candle;
    });
  };
}
