import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event_type.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/ui/debenture_game_event.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/containers/indicators_table.dart';
import 'package:cash_flow/widgets/events/insurance_game_event.dart';
import 'package:cash_flow/widgets/events/property_game_event.dart';
import 'package:cash_flow/widgets/events/sale_business_game_event.dart';
import 'package:cash_flow/widgets/events/windfall_income_game_event.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiKit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DropFocus(
        child: ListView(
          children: <Widget>[
            _getTables(context),
            _getGroupDivider(),
            _getGameEvents(context),
            _getGroupDivider(),
          ],
        ),
      ),
    );
  }

  Widget _getGroupDivider() {
    return const Divider(
      thickness: 32,
      height: 32,
      color: ColorRes.white,
    );
  }

  Widget _getTables(BuildContext context) {
    return Column(
      children: <Widget>[
        IndicatorsTable(
          context: context,
          name: 'Доходы',
          result: '5 500 р',
          rows: const <RowHeaderItem>[
            RowItem(name: 'Зарплата', value: '5 000 p'),
            RowHeaderItem(name: 'Вложения'),
            RowItem(name: 'Вексель', value: '500 p'),
            RowHeaderItem(name: 'Недвижимость'),
            RowHeaderItem(name: 'Бизнес'),
            RowHeaderItem(name: 'Прочие'),
          ],
        ),
        const SizedBox(height: 32),
        IndicatorsTable(
          context: context,
          name: 'Расходы',
          result: '5 070 р',
          rows: const <RowHeaderItem>[
            RowItem(name: 'Общие', value: '4 000 p'),
            RowItem(name: 'Кредит', value: '790 p'),
            RowItem(name: 'Дети', value: '280 p'),
          ],
        ),
        const SizedBox(height: 32),
        IndicatorsTable(
          context: context,
          name: 'Активы',
          result: '10 672 р',
          rows: const <RowHeaderItem>[
            RowItem(name: 'Наличные:', value: '567 p'),
            RowHeaderAttributeItem(
                name: 'Страхование', attribute: 'Стоимость', value: 'Защита'),
            RowAttributeItem(
                name: 'Полис СИ (12)', attribute: '468 р', value: '4 118 р'),
            RowHeaderAttributeItem(
                name: 'Вложения', attribute: 'Количество', value: 'Сумма'),
            RowAttributeItem(
                name: 'Вексель', attribute: '1 шт', value: '10 000 р'),
            RowHeaderAttributeItem(
                name: 'Акции/Фонды', attribute: 'Количество', value: 'Сумма'),
            RowAttributeItem(
                name: 'Связьком', attribute: '1 по 105 р', value: '105 р'),
            RowHeaderAttributeItem(
                name: 'Недвижимость',
                attribute: 'Первый взнос',
                value: 'Стоимость'),
            RowHeaderAttributeItem(
                name: 'Бизнес', attribute: 'Первый взнос', value: 'Стоимость'),
            RowHeaderAttributeItem(
                name: 'Прочие', attribute: 'Первый взнос', value: 'Стоимость'),
          ],
        ),
        const SizedBox(height: 32),
        IndicatorsTable(
          context: context,
          name: 'Пассивы',
          result: '7 900 р',
          rows: const <RowHeaderItem>[
            RowItem(name: 'Кредит:', value: '7 900 p'),
            RowHeaderItem(name: 'Ипотека недвижимости'),
            RowHeaderItem(name: 'Кредиты бизнеса'),
            RowHeaderItem(name: 'Прочие'),
            RowItem(name: 'Общие', value: '0 p'),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _getGameEvents(BuildContext context) {
    return Column(
      children: <Widget>[
        const PropertyGameEvent(
          PropertyViewModel(
            name: 'киоск',
            price: 83000,
            marketPrice: 100000,
            downPayment: 16500,
            debt: 66500,
            passiveIncomePerMonth: -100,
            roi: -7.3,
            saleRate: 14,
          ),
        ),
        DebentureGameEvent(
          event: GameEvent(
            id: 'event1',
            name: 'Облигации',
            description: 'Облигации',
            type: GameEventType.debenture(),
            data: DebentureEventData(
              currentPrice: 1300,
              nominal: 1000,
              profitabilityPercent: 8,
              availableCount: 15,
            ),
          ),
        ),
        const NewBusinessGameEvent(
          NewBusinessViewModel(
            passiveIncomePerMonth: 0,
            roi: 0,
            debt: 0,
            marketPrice: 900,
          ),
        ),
        const WindfallIncomeGameEvent(
          WindfallIncomeViewModel(
            income: 1000,
          ),
        ),
        const SaleBusinessGameEvent(
          SaleBusinessViewModel(
            offeredPrice: 129000,
            marketPrice: 125000,
            downPayment: 22300,
            debt: 106700,
            passiveIncomePerMonth: 100,
            roi: 5.4,
            saleRate: 10,
          ),
        ),
        const InsuranceGameEvent(
          InsuranceViewModel(
            price: 387,
            coverage: 3367,
          ),
        ),
      ],
    );
  }
}
