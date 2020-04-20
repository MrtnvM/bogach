import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class InvestmentsInfo extends StatelessWidget {
  const InvestmentsInfo(
      {this.currentPrice,
      this.name,
      this.nominalValue,
      this.passiveIncomePerNonth,
      this.roiPerYear,
      this.inStock});

  final String currentPrice;
  final String name;
  final String nominalValue;
  final String passiveIncomePerNonth;
  final String roiPerYear;
  final String inStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 226,
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 2.0,
              spreadRadius: 2.0),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          InfoTitle(),
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 14),
            child: Column(
              children: [
                Element(name: 'Текущая цена', value: currentPrice),
                InvestmentsDivider(),
                Element(name: 'Наименование', value: name),
                InvestmentsDivider(),
                Element(name: 'Номинальная стоимость', value: nominalValue),
                InvestmentsDivider(),
                Element(
                    name: 'Пассивный доход за месяц',
                    value: passiveIncomePerNonth),
                InvestmentsDivider(),
                Element(name: 'ROI за год', value: roiPerYear),
                InvestmentsDivider(),
                Element(name: 'В наличии', value: inStock),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Вложения',
                style: TextStyle(
                  color: ColorRes.primaryBackgroundColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            //padding: const EdgeInsets.only(right: 32),
            //color: Colors.red,
            child: Icon(Icons.info_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class Element extends StatelessWidget {
  const Element({this.name, this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text(
              '$name: ',
              style: const TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            //color: ColorRes.newGameBoardPrimaryTextColor,
          ),
        )
      ],
    );
  }
}

class InvestmentsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 15,
        thickness: 1,
        color: ColorRes.newGameBoardInvestmentsDividerColor);
  }
}
