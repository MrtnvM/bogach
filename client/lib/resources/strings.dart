import 'package:intl/intl.dart';

// ignore: avoid_classes_with_only_static_members
class Strings {
  static String get mascotName => 'Богач Бородач';

  static String get unknownErrorTitle => 'Произошла ошибка 😒';
  static String get unknownError =>
      'Давай проверим соединенение с интернетом и попробуем ещё раз';
  static String get storeConnectionError =>
      'При подключении к магазину возникла проблема.\n'
      'Повторите попытку позднее';

  static String get purchaseError => 'При совершении покупки возникла ошибка';

  static String get notEnoughCashError => 'Недостаточно наличных для операции';

  // Common
  static String get submit => 'Отправить';
  static String get select => 'Выбрать';
  static String get logout => 'Выйти из аккаунта';

  // Main Page
  static String get gamesTabTitle => 'Игры';
  static String get accountTabTitle => 'Аккаунт';

  // Authorization
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
      'Вход с $socialNetwork';

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
  static String get financesTabTitleDescription => 'Подробную информацию по '
      'доходам, расходам, активам и пассивам можно посмотреть тут';

  static String get actionsTabTitle => 'Действия';
  static String get progressTabTitle => 'Прогресс';

  static String get monthlyPayment => 'Ежемесячный платеж:';

  static String get waiting => 'Ожидание';
  static String get readyForGame => 'В игре';

  static String get unknownUser => 'Аноним';

  static String get emptyList => 'Список пуст';

  static String get unavailable => 'Недоступно';

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

  static String get cash => 'Наличные';
  static String get cashDescription => 'Cумма денег, которая у тебя на руках';

  static const count = 'Количество';
  static const sum = 'Сумма';
  static const stock = 'Акции';
  static const income = 'Непредвиденный доход';
  static const expense = 'Непредвиденный убыток';
  static const monthlyExpenseEvent = 'Новое событие';
  static const insuranceEvent = 'Страховка';
  static const monthlyExpenseTitle = 'Ежемесячные расходы';
  static String get salaryChangeTitle => 'Зарплата';
  static const property = 'Недвижимость';
  static const salaryChange = 'Изменения в зарплате';
  static const news = 'Новости';
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
  static const changeInPortfolio = 'Измeнение цены:';
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

  static String get restorePurchasesError => 'Не удалось восстановить покупки. '
      'Пожалуйста, проверьте ваше интернет-соединение '
      'и используемый аккаунт для магазина';

  static const cannotAuthoriseThroughSocial =
      'Вы зарегистрированы с указанной почтой через '
      'другую соц. сеть. Выберете ее для авторизации';

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
  static String get cashFlowDescription =>
      'Практически главный показатель в игре\n\n'
      'Это сумма, на которую ты становишься богаче каждый месяц\n\n'
      'Денежный поток - это доходы минус расходы';

  static String get cashFlowShort => 'Поток';

  static String get credit => 'Кредит';
  static String get creditDescription =>
      'Cумма денег, которые ты занял у банка\n\n'
      'Будь осторожен, проценты по кредиту бьют по твоему денежному потоку, '
      'однако кредит может дать быстрый его рост!\n\n'
      'Используй его с умом!';

  static String get monthIsOver => 'Месяц завершен!';

  static String get month => 'Месяц';
  static String get monthDescription => 'Показывает текущий номер месяца '
      'и сколько всего месяцев, есть для осуществления цели';

  static String get currentProgress => 'Текущий прогресс';
  static String get currentProgressDescription =>
      'Это твоя цель с отображением в цифрах текущего прогресса';

  static String get gameEvent => 'Событие';
  static String get gameEventDescription =>
      'В течение месяца ты будешь сталкиваться с набором событий, '
      'в виде покупки/продажи ценных бумаг и бизнесов, доходов и расходов, '
      'страховок и прочего. \n\n'
      'Будь вниматален и принимай верные решения на пути к цели!';

  static String get gameEventActions => 'Действия';
  static String get gameEventActionsDescription =>
      'Здесь Вы можете подтвердить выбор (например: продажу / покупку), '
      'взять в кредит, или просто пропустить событие';

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
  static String get multiplayer => 'Мультиплеер';
  static const continueGame = 'Продолжить игру';
  static const chooseQuest = 'Выберите уровень';
  static const reach = 'Набрать';
  static const goBack = 'Вернуться назад';
  static String get online => 'Онлайн';
  static String get offline => 'Оффлайн';

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
  static String get winnersMultiplayerPageDescription =>
      'Ты достиг своей цели!';

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

  static String games(int number) => Intl.plural(
        number,
        zero: 'игр',
        one: 'игра',
        two: 'игры',
        few: 'игры',
        many: 'игр',
        other: 'игр',
      );

  static String get goToMainMenu => 'В главное меню';
  static String get goToQuests => 'Перейти к квестам';

  static String get sellBusinessNoChecked =>
      'Необходимо выбрать бизнес для продажи';

  // Multiplayer
  static String get selectPlayers => 'Выберите игроков';
  static String get waitingPlayers => 'Ожидание игроков';
  static String get selectedPlayers => 'Выбранные игроки';
  static String get allPlayers => 'Все игроки';
  static String get createRoom => 'Создать комнату';
  static String get inviteByLink => 'Пригласить по ссылке';
  static String get invite => 'Пригласить';
  static String get startGame => 'Начать игру';
  static String get roomCreationFailed =>
      'При создании комнаты возникла ошибка';
  static String get join => 'Присоединиться';
  static String get battleInvitationTitle => 'Вызываю тебя на дуэль!';
  static String get battleInvitationDescription =>
      'приглашает Вас сразиться в поединке капиталистов!';
  static String get joinRoomError =>
      'Не удалось подключиться к комнате игроков';
  static String get multiplayerGamesAvailable => 'Доступно игр:';
  static String get multiplayerAdvertisingMessage =>
      'У вас кончились игры.\nХотите купить ещё?';
  static String get multiplayerAdvertisingMessageWhenHaveGames =>
      'Хотите купить ещё игр?';
  static String get asGift => 'в подарок';
  static String get inviteFriendsToStart =>
      'Пригласите друзей, чтобы начать игру';
  static String get joinToRoom => 'Игра начнётся автоматически, '
      'как только участники присоединятся и лидер начнёт игру';

  // Onboarding
  static String get onboardingTitle1 => 'Финансовая грамотность';
  static String get onboardingDescription1 =>
      'Используй финансовые инструменты для достижения своих целей';

  static String get onboardingTitle2 => 'Денежный поток';
  static String get onboardingDescription2 =>
      'Научись управлять своим денежным потоком для достижения '
      'финансовой свободы';

  static String get onboardingTitle3 => 'Инвестирование';
  static String get onboardingDescription3 =>
      'Попробуй себя в роли инвестора, не рискуя реальными деньгами';

  // Quests access
  static String get quests => 'Квесты';
  static String get questsAccessDescription =>
      ' - это спроектированные сценарии, нацеленные на '
      'тренировку навыков обращения с финансами';
  static String get questsAccessAdvantage1 =>
      'Получи доступ к обновляемой базе квестов';
  static String get questsAccessAdvantage2 => 'Испытай себя в разных ситуациях';
  static String get questsAccessAdvantage3 => 'Найди лучшие стратегии';
  static String get buyQuestsAccess => 'Купить за 149 ₽';
  static String get startQuest => 'Перейти к квесту';
  static String get questsAccessRestorePurchases => 'Восстановить\nпокупки';

  static String get authAndAccept => 'Авторизуясь, вы принимаете ';
  static String get termsOfUse => 'пользовательское соглашение';
  static String get and => ' и ';
  static String get privacyPolicy => 'политику приватности';
  static String get canNotOpenLink => 'Произошла ошибка при открытии ссылки';
  static String get purchase1Game => '1 игра';
  static String get purchase5Game => '5 игр + 1 в подарок';
  static String get purchase10Game => '10 игр + 2 в подарок';

  static String get optimalPath => 'Оптимальный путь';

  // Tutorial
  static String get tutorialQuestName => 'Черный бумер';
  static String get tutorialDebentureExample => 'ОФЗ 29006';
  static String get tutorialGoNext1 => 'Ок';
  static String get tutorialGoNext2 => 'Понятно';
  static String get tutorialGoNext3 => 'Ага';
  static String get tutorialGoNext4 => 'Дальше';
  static String get tutorialGoNext5 => 'Ясно';
  static String get tutorialGoNext6 => 'Хорошо';
  static String get tutorialGoNext7 => 'Ок';
  static String get tutorialFinish => 'Погнали!';
}
