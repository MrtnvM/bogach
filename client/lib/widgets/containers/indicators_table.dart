import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndicatorsTable extends StatelessWidget {
  IndicatorsTable({
    BuildContext context,
    this.icon,
    this.name,
    this.result,
    this.rows,
  })  : textStyle = Theme.of(context).textTheme.subhead,
        assert(rows is List<RowHeaderItem>);

  final String icon;
  final String name;
  final String result;
  final List<RowHeaderItem> rows;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final items = rows.where((key) => key != null).toList();
    final itemsLength = items.length;

    return Container(
      color: ColorRes.gallery,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(context),
          for (int i = 0; i < itemsLength; i++)
            _getRow(context, items[i], i % 2 == 0),
        ],
      ),
    );
  }

  Widget _getRow(BuildContext context, RowHeaderItem item, bool isDark) {
    final backgroundColor = isDark ? ColorRes.gallery : ColorRes.white;

    Widget child = Container();

    switch (item.runtimeType) {
      case RowHeaderItem:
        child = _buildRowHeaderItem(context, item);
        break;
      case RowItem:
        child = _buildRowItem(context, item);
        break;
      case RowHeaderAttributeItem:
        child = _buildRowHeaderAttributeItem(context, item);
        break;
      case RowAttributeItem:
        child = _buildRowAttributeItem(context, item);
        break;
    }

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: child,
    );
  }

  Widget _buildRowHeaderItem(BuildContext context, RowHeaderItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          item.name,
          style: textStyle.copyWith(
            fontStyle: FontStyle.italic,
            color: ColorRes.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRowItem(BuildContext context, RowItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          item.name,
          style: textStyle,
        ),
        const Spacer(),
        Text(item.value, style: textStyle),
      ],
    );
  }

  Widget _buildRowHeaderAttributeItem(
    BuildContext context,
    RowHeaderAttributeItem item,
  ) {
    final style = textStyle.copyWith(
      fontStyle: FontStyle.italic,
      color: ColorRes.blue,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            item.name,
            style: style,
          ),
          flex: 13,
        ),
        Expanded(
          child: Text(
            item.attribute,
            style: style,
            textAlign: TextAlign.end,
          ),
          flex: 10,
        ),
        Expanded(
          child: Text(
            item.value,
            style: style,
            textAlign: TextAlign.end,
          ),
          flex: 10,
        ),
      ],
    );
  }

  Widget _buildRowAttributeItem(
    BuildContext context,
    RowAttributeItem item,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            item.name,
            style: textStyle,
          ),
          flex: 13,
        ),
        Expanded(
          child: Text(
            item.attribute,
            style: textStyle,
            textAlign: TextAlign.end,
          ),
          flex: 10,
        ),
        Expanded(
          child: Text(
            item.value,
            style: textStyle,
            textAlign: TextAlign.end,
          ),
          flex: 10,
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: ColorRes.grey,
      child: Row(
        children: <Widget>[
          Text(name.toUpperCase(), style: Theme.of(context).textTheme.subhead),
          const Spacer(),
          Text(result, style: Theme.of(context).textTheme.subhead),
        ],
      ),
    );
  }
}

class RowHeaderItem {
  const RowHeaderItem({this.name});

  final String name;
}

class RowItem extends RowHeaderItem {
  const RowItem({
    this.value,
    String name,
  }) : super(name: name);

  final String value;
}

class RowHeaderAttributeItem extends RowItem {
  const RowHeaderAttributeItem({
    this.attribute,
    String name,
    String value,
  }) : super(name: name, value: value);
  final String attribute;
}

class RowAttributeItem extends RowHeaderAttributeItem {
  const RowAttributeItem({
    String attribute,
    String name,
    String value,
  }) : super(name: name, attribute: attribute, value: value);
}
