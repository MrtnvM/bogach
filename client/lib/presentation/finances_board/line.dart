import 'package:cash_flow/presentation/finances_board/detail_row.dart';
import 'package:cash_flow/presentation/finances_board/table_row.dart';
import 'package:flutter/material.dart' hide TableRow;

class Line {
  List<TableRow> incomes = [
    TableRow(title: 'Вложения', value: ''),
    TableRow(title: 'Недвижимость', value: ''),
    TableRow(title: 'Бизнес', value: ''),
    TableRow(title: 'Прочие', value: ''),
  ];

  List<TableRow> expanses = [
    TableRow(title: 'Общие', value: ''),
  ];

  List<Widget> actives = [
    DetailRow(
      title: 'Страхование',
      value: '',
      details: const ['Полис Си - защита'],
    ),
    DetailRow(
      title: 'Акции/Фонды',
      value: '',
      details: const ['Связьком 20 по 85₽'],
    ),
  ];

  List<Widget> passives = [
    DetailRow(
      title: 'Кредит',
      value: '123123',
      details: const [
        'Ипотека недвижимости - 500₽',
        'Кредиты бизнеса - 500₽',
        'Прочие - 500₽'
      ],
    ),
    DetailRow(title: 'Общие', value: ''),
  ];
}
