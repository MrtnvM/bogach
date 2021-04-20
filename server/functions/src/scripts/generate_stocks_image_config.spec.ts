/// <reference types="@types/jest"/>

import * as fs from 'fs';
import * as path from 'path';
import { readJsonFile, writeJson } from '../utils/json';

const dataPath = path.join(__dirname, '..', '..', 'data');
const stocksPath = `${dataPath}/stocks_history`;
const stocksConfigPath = `${dataPath}/stocks`;
export const stocksImagesConfigPath = `${stocksConfigPath}/stocks_images_config.json`;

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

    writeJson(stocksImagesConfigPath, stocksImages);

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
  if (!fs.existsSync(stocksImagesConfigPath)) {
    if (!fs.existsSync(dataPath)) {
      fs.mkdirSync(dataPath);
    }

    if (!fs.existsSync(stocksConfigPath)) {
      fs.mkdirSync(stocksConfigPath);
    }

    fs.writeFileSync(stocksImagesConfigPath, '{}');
  }

  const stocksImages: { [stock: string]: string | null } =
    (await readJsonFile(stocksImagesConfigPath)) || {};
  return stocksImages;
};
