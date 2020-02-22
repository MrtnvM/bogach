class Strings {
  static const unknownError =
      'An error occurred while performing the operation';

  static const title = '';
  static const confirm = 'ОК';
  static const cancel = 'Отмена';
  static const warning = 'Внимание';
  static const retry = 'Повторить';
  static const skip = 'Пропустить';

  static const commonError = 'Произошла ошибка';

  static const propertyName = 'Малая недвижимость';
  static const offeredPrice = 'Предложенная цена:';
  static const marketPrice = 'Среднерыночная цена:';
  static const downPayment = 'Первый взнос:';
  static const debt = 'Долг:';
  static const passiveIncomePerMonth = 'Пассивный доход за месяц:';
  static const roi = 'ROI за год';
  static const saleRate = 'Вероятность продажи';
  static const takeLoan = 'Взять кредит';

  static const investments = 'Вложения';
  static const currentPrice = 'Текущая цена:';
  static const investmentType = 'Наименование:';
  static const nominalCost = 'Номинальная стоимость:';
  static const alreadyHave = 'В наличии:';
  static const incomePerMonth = 'Ежемесячный доход:';
  static const available = 'Доступно:';
  static const buyAllAvailable = 'Купить на все';
  static String getUserAvailableCount(String count, String cost) => '$count по $cost';


  static String getSelling(String name) => 'Продается $name';

  static const noInternetError =
      'Не удалось подключиться к серверу. '
      'Пожалуйста, проверьте ваше интернет-соединение';
}
