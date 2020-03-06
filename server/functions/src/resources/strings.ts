export namespace Strings {
  export const debetures = () => get('debetures');
}

const strings: { [key: string]: string } = {
  debetures: 'Облигации'
};

const get = (key: string): string => strings[key];
