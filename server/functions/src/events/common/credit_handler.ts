export interface CreditParameters {
  readonly userCashFlow: number;
  readonly userCash: number;
  readonly priceToPay: number;
}

export interface CreditResult {
  readonly isAvailable: boolean;
  readonly monthlyPayment: number;
  readonly creditSum: number;
}

export class CreditHandler {
  isCreditAvailable(parameters: CreditParameters): CreditResult {
    const { userCashFlow, userCash, priceToPay } = parameters;

    const creditSum = priceToPay - userCash;
    const monthlyPayment = Math.round(creditSum / 12);

    const isAvailable = userCashFlow > monthlyPayment;

    const creditResult: CreditResult = {
      isAvailable,
      monthlyPayment,
      creditSum,
    };

    return creditResult;
  }
}
