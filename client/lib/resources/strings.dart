import 'package:intl/intl.dart';

// ignore: avoid_classes_with_only_static_members
class Strings {
  static String get unknownErrorTitle => 'Произошла ошибка 😒';
  static String get unknownError =>
      'Давай проверим соединенение с интернетом и попробуем ещё раз';

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

  static String get start => 'Начать';

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

  static String get waiting => 'Ожидание';
  static String get readyForGame => 'В игре';

  static String get unknownUser => 'Аноним';

  static String get emptyList => 'Список пуст';

  static const rubleSymbol = '₽';
  static const title = '';
  static const wordIn = 'в';
  static const ok = 'ОК';
  static const confirm = 'Подтвердить';
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
  static const stock = 'Акции';
  static const income = 'Непредвиденный доход';
  static const expense = 'Непредвиденный убыток';
  static const monthlyExpenseEvent = 'Новое событие';
  static const insuranceEvent = 'Страховка';
  static const monthlyExpenseTitle = 'Ежемесячные расходы';
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
  static String get debentures => 'Облигации';
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
  static const fairPrice = 'Справедливая цена:';
  static const sellProbability = 'Вероятность продажи:';
  static String get yearAvaragePrive => 'Среднегодовая цена:';

  static const newBusinessTitle = 'Новый бизнесс';

  static const windfallIncomeTitle = 'Непредвиденные доходы';
  static const windfallIncomeDesc = 'Получили премию на работе';
  static const windfallIncome = 'Сумма дохода:';

  static const stockMarketTitle = 'Фондовый рынок';

  static const insuranceTitle = 'Страхование';
  static const insuranceDuration = 'Срок действия (мес.)';
  static const insuranceValue = 'Защита';

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
  static const businessSell = 'Продажа бизнеса';
  static const realty = 'Недвижимость';
  static const other = 'Прочие';

  static const riskLevel = 'Риск';
  static const profitabilityLevel = 'Доходность';
  static const complexityLevel = 'Сложность';

  static const debentureDialogTitle = 'Облигации';
  static const debentureDialogDescription =
      'Облигации - когда вы даёте деньги в долг государству или компании';
  static const debentureDialogKeyPoint1 = 'Как заработать';
  static const debentureDialogKeyPointDescription1 =
      'на процентах - должник возвращает больше денег, чем взял.';
  static const debentureDialogKeyPoint2 = 'Кому подойдёт';
  static const debentureDialogKeyPointDescription2 =
      'консервативным инвесторам, которые не хотят рисковать, '
      'но хотят доходность выше, чем по банковскому вкладу.';

  static const stockDialogTitle = 'Акции';
  static const stockDialogDescription =
      'Акции - когда вы покупаете часть компании';
  static const stockDialogKeyPoint1 = 'Как заработать';
  static const stockDialogKeyPointDescription1 =
      'на дивидендах - когда компания делится с акционером частью прибыли;'
      ' на росте стоимости акций - когда бизнес компании растёт,'
      ' спрос на её акции повышается и цена акций растёт.';
  static const stockDialogKeyPoint2 = 'Кому подойдёт';
  static const stockDialogKeyPointDescription2 =
      'инвесторам, которые готовы потратить время,'
      ' разобраться и выбрать хорошие акции.';

  static const realEstateDialogTitle = 'Недвижимость';
  static const realEstateDialogDescription =
      'Недвижимость - вы покупаете недвижимость, ожидая,'
      ' что цена вырастет, или хотите сдавать в аренду';
  static const realEstateDialogKeyPoint1 = 'Как заработать';
  static const realEstateDialogKeyPointDescription1 =
      'на росте стоимости - цена сданной застройщиком квартиры выше,'
      ' чем на этапе строительства,'
      ' квартира будет стоить больше, если рядом появится метро;'
      ' на сдаче в аренду - квартира в Москве окупится в среднем через 15 лет.';
  static const realEstateDialogKeyPoint2 = 'Кому подойдёт';
  static const realEstateDialogKeyPointDescription2 =
      'тем, у кого есть достаточно денег для приобретения квартиры'
      ' и финансовая подушка.';

  static const businessDialogTitle = 'Бизнес';
  static const businessDialogDescription =
      'Бизнес - вы покупаете бизнес, ожидая,'
      ' что вы будете получать ежемсячный доход и цена бизнеса вырастет';
  static const businessDialogKeyPoint1 = 'Как заработать';
  static const businessDialogKeyPointDescription1 =
      'ежемесячный доход - бизнес каждый месяц приносит доход;'
      ' на продаже - цена бизнеса изменяется,'
      ' и вы можете выгодно его продать.';
  static const businessDialogKeyPoint2 = 'Кому подойдёт';
  static const businessDialogKeyPointDescription2 =
      'тем, у кого есть достаточно денег для приобретения бизнеса'
      ' и финансовая подушка.';

  static const insuranceDialogTitle = 'Страховка';
  static const insuranceDialogDescription =
      'Страховка - вы покупаете страховку, ожидая,'
      ' что она покроет бо́льшие траты, чем её стоимость';
  static const insuranceDialogKeyPoint1 = 'Как заработать';
  static const insuranceDialogKeyPointDescription1 =
      'в случае наступления страхового случая'
      ' вы экономите сумму определенного размера.';
  static const insuranceDialogKeyPoint2 = 'Кому подойдёт';
  static const insuranceDialogKeyPointDescription2 =
      'тем, кто хочет обезопасить долю своего капитала от рисков'
      '(машина, недвижимость), или защитить себя финансово'
      ' от несчастного случая';

  static String get monthResult => 'Итоги за месяц';
  static String get financialResults => 'Финансовые показатели';
  static String get financialResultsChange => 'Изменения показателей';
  static String get total => 'Итого';

  static String get waitingPlayersList => 'Ждем хода игроков';

  static String get gameBoardTitle => 'GameBoard';

  static String get targetTypeCash => 'Капитал';

  static String get targetTypePassiveIncome => 'Пассивный доход';

  static String get cashFlow => 'Денежный поток';

  static String get cashFlowShort => 'Поток';

  static String get credit => 'Кредит';

  static String get monthIsOver => 'Месяц завершен!';

  static String get monthsPast => 'Прошло месяцев';

  static String get noGameEvents => 'Произошла ошибка.\nНет игровых событий';

  // Log in errors
  static String get invalidCredentials => 'Неправильный логин или пароль';

  static String get passwordAreDifferent => 'Пароли не совпадают';

  static String get incorrectEmail => 'Некорректный e-mail адрес';

  static String get incorrectPassword =>
      'Пароль должен быть более 6-ти символов';

  // New Game
  static const chooseGame = 'Выберите игру';
  static const singleGame = 'Одиночная игра';
  static String get gameLevels => 'Квесты';
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
  static String get winnersPageTitle => 'Поздравляем!';
  static String get winnersPageDescription => 'Ты достиг своей цели всего за';

  static String get gameFailedPageTitle => 'Цель не достигнута!';
  static String get gameFailedPageDescription =>
      'Ты явно можешь лучше!\nНужна еще одна попытка!';

  static String get startAgain => 'Начать заново';

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

  static String get sellBusinessNoChecked =>
      'Необходимо выбрать бизнес для продажи';

  // Multiplayer
  static String get selectPlayers => 'Выбeрете игроков';
  static String get waitingPlayers => 'Ожидание игроков';
  static String get selectedPlayers => 'Выбранные игроки';
  static String get allPlayers => 'Все игроки';
  static String get createRoom => 'Создать комнату';
  static String get inviteByLink => 'Пригласить по ссылке';
  static String get startGame => 'Начать игру';
  static String get roomCreationFailed =>
      'При создании комнаты возникла ошибка';
  static String get join => 'Присоединиться';
  static String get battleInvitationTitle => 'Вызываю тебя на дуэль!';
  static String get battleInvitationDescription =>
      'приглашает Вас сразиться в поединке капиталистов!';
  static String get joinRoomError =>
      'Не удалось подключиться к комнате игроков';
}
