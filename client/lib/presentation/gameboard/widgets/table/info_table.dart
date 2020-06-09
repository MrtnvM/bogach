import 'package:cash_flow/presentation/gameboard/widgets/table/table_divider.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:flutter/material.dart';

class InfoTable extends StatelessWidget {
  const InfoTable({
    Key key,
    this.title,
    this.titleValue,
    this.rows,
  }) : super(key: key);

  final String title;
  final String titleValue;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          TableDivider(),
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) TableDivider(),
          ]
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Styles.tableHeaderTitle),
        ),
        if (titleValue != null)
          Text(titleValue, style: Styles.tableHeaderValue),
      ],
    );
  }
}
