/// <reference types="@types/jest"/>

import { CreditHandler, CreditParameters, CreditResult } from './credit_handler';

describe('Credit handler', () => {
  test('Successfully get new credit', async () => {
    const handler = new CreditHandler();

    const creditParameters: CreditParameters = {
      userCashFlow: 10_000,
      userCash: 0,
      priceToPay: 120_000,
    };
    const creditResult = handler.isCreditAvailable(creditParameters);

    const expectedCreditResult: CreditResult = {
      isAvailable: true,
      monthlyPayment: 10_000,
      creditSum: 120_000,
    };

    expect(creditResult).toStrictEqual(expectedCreditResult);
  });

  test('Credit not available', async () => {
    const handler = new CreditHandler();

    const creditParameters: CreditParameters = {
      userCashFlow: 9999,
      userCash: 0,
      priceToPay: 120_000,
    };
    const creditResult = handler.isCreditAvailable(creditParameters);

    const expectedCreditResult: CreditResult = {
      isAvailable: false,
      monthlyPayment: 10_000,
      creditSum: 120_000,
    };

    expect(creditResult).toStrictEqual(expectedCreditResult);
  });

  test('Check rounding monthly payment from 8333.3333 to 8333', async () => {
    const handler = new CreditHandler();

    const creditParameters: CreditParameters = {
      userCashFlow: 10_000,
      userCash: 0,
      priceToPay: 100_000,
    };
    const creditResult = handler.isCreditAvailable(creditParameters);

    const expectedCreditResult: CreditResult = {
      isAvailable: true,
      monthlyPayment: 8333,
      creditSum: 100_000,
    };

    expect(creditResult).toStrictEqual(expectedCreditResult);
  });

  test('Check rounding monthly payment from 8333.9 to 8333', async () => {
    const handler = new CreditHandler();

    const creditParameters: CreditParameters = {
      userCashFlow: 10_000,
      userCash: 0,
      priceToPay: 100_006.8,
    };
    const creditResult = handler.isCreditAvailable(creditParameters);

    const expectedCreditResult: CreditResult = {
      isAvailable: true,
      monthlyPayment: 8333,
      creditSum: 100_006.8,
    };

    expect(creditResult).toStrictEqual(expectedCreditResult);
  });
});
