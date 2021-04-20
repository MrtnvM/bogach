/// <reference types="@types/jest"/>

import { getStocksImages, updateStocksImagesConfig } from './generate_stocks_image_config';

describe('Stocks Images', () => {
  test('Generate & Check Stocks Images', async () => {
    await updateStocksImagesConfig();

    const stocksImages = await getStocksImages();

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
