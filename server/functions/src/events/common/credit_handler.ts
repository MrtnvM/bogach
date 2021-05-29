interface CreditParameters {
      readonly userCashFlow: number;
      readonly userCash: number;
      readonly priceToPay: number;
 }

export class CreditHandler {

     isCreditAvailable(parameters: CreditParameters): boolean {
            const {
                  userCashFlow, 
                  userCash,   
                  priceToPay,
            } = parameters;

            const sumToCredit = priceToPay - userCash;
            const monthlyPayment = sumToCredit / 12;

            return userCashFlow > monthlyPayment;
            // TODO наверно отсюда передавать параметры кредита
      }
}