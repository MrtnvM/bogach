export namespace Strings {
  export const debetures = () => get('debetures');
  export const realty = () => get('realty');
  export const debeturesTitle = () => get('debeturesTitle');
  export const stocksTitle = () => get('stocksTitle');
  export const currentPrice = () => get('currentPrice');
}

const strings: { [key: string]: string } = {
  currentPrice: 'Текущая цена: ',

  debetures: 'Облигации',
  realty: 'Недвижимость',

  debeturesTitle: 'Вложения',
  stocksTitle: 'Акции',
};

const get = (key: string): string => strings[key];
