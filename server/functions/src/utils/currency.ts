export enum Currency {
  Ruble,
}

const currencySigns = {
  [Currency.Ruble]: '₽',
};

export const formatPrice = (price: number, currency: Currency = Currency.Ruble) => {
  const currencySign = currencySigns[currency] ?? '';
  return `${price ?? 0} ${currencySign}`;
};
