// ignore: avoid_classes_with_only_static_members
class Strings {
  static const unknownError =
      'An error occurred while performing the operation';

  static const title = '';
  static const confirm = 'ОК';
  static const cancel = 'Отмена';
  static const warning = 'Внимание';
  static const retry = 'Повторить';
  static const skip = 'Пропустить';
  static const fieldIsRequired = 'Необходимо заполнить';
  static const continueAction = 'Продолжить';
  static const buy = 'Купить';
  static const price = 'Стоимость:';
  static const cost = 'Стоимость';
  static const defence = 'Защита';
  static const cash = 'Наличные:';
  static const count = 'Количество';
  static const sum = 'Сумма';
  static const stock = 'Акции/Фонды';
  static const property = 'Недвижимость';
  static const firstPayment = 'Первый взнос';

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
  static const sellAllAvailable = 'Продать все';
  static const purchasing = 'Покупка';
  static const selling = 'Продажа';
  static const inputCount = 'Количество:';

  static const newBusinessTitle = 'Новый бизнесс';
  static const newBusinessDesc =
      'Возможность попробовать себя в бизнесе прямых продаж.';

  static const windfallIncomeTitle = 'Непредвиденные доходы';
  static const windfallIncomeDesc = 'Получили премию на работе';
  static const windfallIncome = 'Сумма дохода:';

  static const stockMarketTitle = 'Фондовый рынок';

  static const insuranceTitle = 'Страхование';
  static const insuranceDesc = 'Полис страхования имущества';
  static const insurance = 'Страховая компания предлагает вам купить полис и '
      'защитить свое имущество от неприятностей. Действие полиса 1 год.';
  static const coverage = 'Защита:';

  static const smallBusinessTitle = 'Малый бизнесс';
  static const smallBusinessDesc = 'Продается терминал платежных систем';

  static String getUserAvailableCount(String count, String cost) =>
      '$count по $cost';

  static String getSelling(String name) => 'Продается $name';

  static String stocks(String name) => 'Акции "$name"';

  static String itemsPerPrice({int count, String price}) => '$count по $price';

  static const noInternetError = 'Не удалось подключиться к серверу. '
      'Пожалуйста, проверьте ваше интернет-соединение';

  static const incomes = 'Доходы';
  static const expenses = 'Расходы';
  static const assets = 'Активы';
  static const liabilities = 'Пассивы';
  static const salary = 'Зарплата';
  static const business = 'Бизнес';
  static const realty = 'Недвижимость';
  static const other = 'Прочие';

  static String get gameBoardTitle => 'GameBoard';

  static String get targetTypeCash => 'Капитал';
}
