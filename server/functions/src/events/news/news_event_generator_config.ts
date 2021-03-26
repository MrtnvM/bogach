export namespace NewsEventGeneratorConfig {
  export type NewsEventInfo = {
    readonly name: string;
    readonly description: string;
    readonly imageUrl: string;
  };

  export const allNews: NewsEventInfo[] = [
    {
      name: 'Коронавирус в России: смертность в 2020 году выросла почти на 18%',
      description: 'Смертность в России по итогам 2020 года, ' +
      'по предварительным данным, оказалась ' +
      'на 17,9% выше, чем в 2019 году. В декабре ' +
      'умерл более 44 тысяч заразившихся ' +
      'коронавирусом - больше, чем в другие месяцы. ' +
      'Общее число умерших превысило 162 тысячи. ' +
      'При этом суточный прирост Covid-19 впервые ' +
      'с октября оказался ниже 16 тысяч заражений.',
      imageUrl: 'http://google.com',
    },
  ];
}
