export namespace Strings {
  export const debetures = () => get('debetures');
  export const realty = () => get('realty');
}

const strings: { [key: string]: string } = {
  debetures: 'Облигации',
  realty: 'Недвижимость'
};

const get = (key: string): string => strings[key];
