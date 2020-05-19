export namespace Strings {
  export const debetures = () => get('debetures');
  export const realty = () => get('realty');
  export const currentPrice = () => get('currentPrice');
}

const strings: { [key: string]: string } = {

  debetures: 'Облигации',
  stocks: 'Акции',
  realty: 'Недвижимость',
};

const get = (key: string): string => strings[key];
