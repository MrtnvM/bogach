import 'package:cash_flow/presentation/gameboard/widgets/table/table_divider.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoTable extends StatelessWidget {
  const InfoTable({
    Key key,
    this.title,
    this.titleValue,
    this.description,
    this.rows,
    this.titleTextStyle = Styles.tableHeaderTitleBlack,
    this.titleValueStyle = Styles.tableHeaderValueBlack,
    this.withShadow = true,
    this.onInfoClick,
  }) : super(key: key);

  final String title;
  final String titleValue;
  final String description;
  final List<Widget> rows;
  final TextStyle titleTextStyle;
  final TextStyle titleValueStyle;
  final bool withShadow;
  final VoidCallback onInfoClick;

  @override
  Widget build(BuildContext context) {
    if (withShadow) {
      return CardContainer(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: _buildBody(),
      );
    }
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ..._buildHeader(),
        const TableDivider(),
        for (var i = 0; i < rows.length; i++) ...[
          rows[i],
          if (i != rows.length - 1) const TableDivider(),
        ]
      ],
    );
  }

  List<Widget> _buildHeader() {
    return <Widget>[
      Row(
        children: [
          Expanded(
            child: Text(title, style: titleTextStyle),
          ),
          if (titleValue != null) Text(titleValue, style: titleValueStyle),
          if (onInfoClick != null) _buildInfoIcon()
        ],
      ),
      if (description != null) ...<Widget>[
        const SizedBox(height: 16),
        Container(
          color: Colors.black,
          alignment: Alignment.centerLeft,
          child: Text(
            description,
            style: Styles.tableRowDetails,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
        )
      ],
    ];
  }

  SizedBox _buildInfoIcon() {
    return SizedBox(
      width: 16,
      height: 16,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        iconSize: 16,
        icon: SvgPicture.asset(
          Images.infoIcon,
          width: 16,
          height: 16,
        ),
        onPressed: onInfoClick,
      ),
    );
  }
}
