/// <reference types="@types/jest"/>

import { Purchases } from './purchases';

describe('Purchases', () => {
  test('Successfully hash product ID', async () => {
    const productId = Purchases.id('test-product-id');
    expect(productId).toEqual('b206b8cfb36a676b9e21ee2fc02801d8515ffadeb69e22cf33228fb860395d78');
  });
});
