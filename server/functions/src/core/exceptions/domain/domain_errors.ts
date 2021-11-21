/// Object that contains all supported locales
/// Key - locale code, value - localized message
export interface LocalizedMessage {
  ru: string;
}

export interface DomainError {
  type: 'domain';
  code: string;
  message: LocalizedMessage;
}

export namespace DomainErrors {
  export const notEnoughCash: DomainError = {
    type: 'domain',
    code: 'not-enough-cash',
    message: {
      ru: 'Недостаточно наличных для операции',
    },
  };

  export const notEnoughStocksOnMarket: DomainError = {
    type: 'domain',
    code: 'not-enough-stocks-on-market',
    message: {
      ru: 'На рынке отсутствует запрашиваемое количество акций по текущей цене',
    },
  };

  export const notEnoughStocksInPortfolio: DomainError = {
    type: 'domain',
    code: 'not-enough-stocks-in-portfolio',
    message: {
      ru: 'В вашем портфеле недостаточно акций для совершения операции',
    },
  };

  export const notEnoughDebenturesOnMarket: DomainError = {
    type: 'domain',
    code: 'not-enough-debentures-on-market',
    message: {
      ru: 'На рынке отсутствует запрашиваемое количество облигаций по текущей цене',
    },
  };

  export const notEnoughDebenturesDemandForSell: DomainError = {
    type: 'domain',
    code: 'not-enough-debentures-demand-for-sell',
    message: {
      ru: 'На рынке отсутствует спрос на указанное количество облигаций по текущей цене',
    },
  };

  export const notEnoughDebenturesInPortfolio: DomainError = {
    type: 'domain',
    code: 'not-enough-debentures-in-portfolio',
    message: {
      ru: 'В вашем портфеле недостаточно облигаций для совершения операции',
    },
  };

  export const participantsLimit: DomainError = {
    type: 'domain',
    code: 'participants-limit',
    message: {
      ru: 'Достигнут предел в количестве участников игры',
    },
  };

  export const creditIsNotAvailable: DomainError = {
    type: 'domain',
    code: 'credit-not-available',
    message: {
      ru: 'Вы не можете взять кредит, так как ваш денежный поток станет отрицательным',
    },
  };
}
