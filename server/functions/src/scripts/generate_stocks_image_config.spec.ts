/// <reference types="@types/jest"/>

import * as fs from 'fs';
import { readJsonFile, writeJson } from '../utils/json';

const dataPath = 'server/functions/data';
const stocksPath = `${dataPath}/stocks_history`;
const stocksConfigPath = `${dataPath}/stocks`;
const path = `${stocksConfigPath}/stocks_image_config.json`;

describe('Stocks Images', () => {
  test('Generate & Check Stocks Images', async () => {
    const stocksImages = await getStocksImages();

    const stockList = fs.readdirSync(stocksPath).map((stockPath) => {
      const pathComponents = stockPath.split('/');
      const fileName = pathComponents[pathComponents.length - 1];
      const stockName = fileName.replace('.json', '');
      return stockName;
    });

    for (const stockName of stockList) {
      stocksImages[stockName] = stocksImages[stockName] || null;
    }

    writeJson(path, stocksImages);

    const emptyStockImages = Object.keys(stocksImages)
      .map((stockName) => [stockName, stocksImages[stockName]])
      .filter(([stockName, image]) => !image);

    if (emptyStockImages.length > 0) {
      console.error(
        'No images for stocks: ',
        emptyStockImages.map(([stockName]) => stockName)
      );
    }

    expect(emptyStockImages.length).toEqual(0);
  });
});

const getStocksImages = async () => {
  if (!fs.existsSync(path)) {
    if (!fs.existsSync(dataPath)) {
      fs.mkdirSync(dataPath);
    }

    if (!fs.existsSync(stocksConfigPath)) {
      fs.mkdirSync(stocksConfigPath);
    }

    fs.writeFileSync(path, '{}');
  }

  const stocksImages: { [stock: string]: string | null } = (await readJsonFile(path)) || {};
  return stocksImages;
};
