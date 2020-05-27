import 'package:intl/intl.dart';

// ignore: avoid_classes_with_only_static_members
class Strings {
  static const unknownError =
      'An error occurred while performing the operation';

  // Common
  static String get submit => 'Отправить';

  static String get email => 'Email';

  static String get password => 'Пароль';

  static String get loginTitle => 'Авторизоваться';

  static String get signUpTitle => 'Зарегистрироваться';

  static String get registrationTitle => 'Регистрация';

  static String get doYouWantToLogin => 'Хотите авторизироваться?';

  static String get emailHasBeenTaken => 'Пользователь с таким e-mail '
      'адресом уже зарегистрирован';

  static String get facebook => 'Facebook';

  static String get google => 'Google';

  static String get vk => 'Vk';

  static String get apple => 'Apple';

  static String getAuthButtonTitle(String socialNetwork) =>
      'Войти через $socialNetwork';

  static String get labelRepeatPassword => 'Повторите пароль';

  static String get labelPassword => 'Пароль';

  static String get labelEmail => 'E-mail';

  static String get labelNickName => 'Ник';

  static String get hintRepeatPassword => 'Повторите желаемый пароль';

  static String get hintPassword => 'Введите желаемый пароль';

  static String get hintEmail => 'Введите свой email адрес';

  static String get hintNickName => 'Введите желаемое имя';

  static String get regAgreementStart => 'Я прочитал и принимаю ';

  static String get regAgreementTermsOfUse => 'правила пользования';

  static String get regAgreementAnd => ' и ';

  static String get regAgreementPrivacyPolicy => 'политику конфиденциальности';

  static String get notImpelementedAlertTitle => 'Кек';
  static String get notImpelementedAlertMessage =>
      'Кажется ты нашел функционал, над которым мы усердно работаем';

  static String get financesTabTitle => 'Финансы';
  static String get actionsTabTitle => 'Действия';
  static String get historyTabTitle => 'История';

  static String get monthlyPayment => 'Ежемесячный платеж:';

  static const rubleSymbol = '₽';
  static const title = '';
  static const wordIn = 'в';
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
  static const cash = 'Наличные';
  static const count = 'Количество';
  static const sum = 'Сумма';
  static const stock = 'Акции/Фонды';
  static const income = 'Непредвиденный доход';
  static const expense = 'Непредвиденный убыток';
  static const property = 'Недвижимость';
  static const firstPayment = 'Первый взнос';

  static const commonError = 'Произошла ошибка';
  static const commonReload = 'Обновить';
  static const emptyData = 'Ничего не найдено';

  static const propertyName = 'Малая недвижимость';
  static const description = 'Описание';
  static const offeredPrice = 'Предложенная цена:';
  static const marketPrice = 'Среднерыночная цена:';
  static const downPayment = 'Первый взнос:';
  static const debt = 'Долг:';
  static const passiveIncomePerMonth = 'Пассивный доход за месяц:';
  static const roi = 'ROI за год:';
  static const saleRate = 'Вероятность продажи';
  static const takeLoan = 'Взять\nкредит';

  static const investments = 'Вложения';
  static const currentPrice = 'Текущая цена:';
  static const investmentType = 'Наименование:';
  static const nominalCost = 'Номинальная стоимость:';
  static const alreadyHave = 'В наличии:';
  static const incomePerMonth = 'Ежемесячный доход:';
  static const available = 'Доступно:';
  static const buyAllAvailable = 'Купить на все';
  static const sellAllAvailable = 'Продать все';
  static const purchasing = 'Купить';
  static const selling = 'Продать';
  static const inputCount = 'Количество:';
  static const fairPrice = 'Справедливая цена:';

  static const newBusinessTitle = 'Новый бизнесс';

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

  static String get targetTypePassiveIncome => 'Пассивный доход';

  static String get cashFlow => 'Денежный поток';

  static String get cashFlowShort => 'Поток';

  static String get credit => 'Кредит';

  static String get monthIsOver => 'Месяц завершен!';

  // Log in errors
  static String get invalidCredentials => 'Неправильный логин или пароль';

  static String get passwordAreDifferent => 'Пароли не совпадают';

  static String get incorrectEmail => 'Некорректный e-mail адрес';

  static String get incorrectPassword =>
      'Пароль должен быть более 6-ти символов';

  // New Game
  static const chooseGame = 'Выберите игру';
  static const singleGame = 'Одиночная игра';
  static const multiPlayerGame = 'Игра с друзьями';
  static const continueGame = 'Продолжить игру';
  static const chooseLevel = 'Выберите уровень';
  static const reach = 'Набрать';
  static const goBack = 'Вернуться назад';

  // Reset Password
  static String get forgotPasswordTitle => 'Забыли пароль?';

  static String get recoveryPasswordTitle => 'Восстановление пароля';

  static String get recoveryPasswordDesc =>
      'Введите свой e-mail, указанный при регистрации';

  static String get noSuchEmail =>
      'Пользователь с таким e-mail не зарегистрирован';

  static String get purchases => 'Покупки';

  static String get storesUnavailable => 'Не удалось подключиться к магазину '
      'приложений.\nПожалуйста, Повторите попытку позже.';

  // Winners Page
  static String get winnersPageTitle => 'Еее, бой!';
  static String get winnersPageDescription =>
      'Поздравляем! \n' 'Ты достиг своей цели всего за';
  static String months(int number) => Intl.plural(
        number,
        zero: 'месяцев',
        one: 'месяц',
        two: 'месяца',
        few: 'месяца',
        many: 'месяцев',
        other: 'месяцев',
      );
  static String get goToMainMenu => 'В главное меню';

  // Multiplayer
  static String get selectPlayers => 'Выбрете игроков';
  static String get selectedPlayers => 'Выбранные игроки';
  static String get allPlayers => 'Все игроки';
}
