import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/table_divider.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoTable extends StatelessWidget {
  const InfoTable({
    Key key,
    this.title,
    this.titleValue,
    this.subtitle,
    this.image,
    this.description,
    this.rows,
    this.titleTextStyle = Styles.tableHeaderTitleBlack,
    this.titleValueStyle = Styles.tableHeaderValueBlack,
    this.withShadow = true,
    this.onInfoClick,
  }) : super(key: key);

  final String title;
  final String titleValue;
  final String subtitle;
  final String image;
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
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: 20,
        ),
        child: _buildBody(context),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      key: GameboardTutorialWidget.of(context)?.gameEventKey,
      children: <Widget>[
        ..._buildHeader(),
        if (rows.isNotEmpty) ...[
          const TableDivider(),
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) const TableDivider(),
          ]
        ]
      ],
    );
  }

  List<Widget> _buildHeader() {
    return <Widget>[
      Row(
        children: [
          Expanded(child: _buildHeaderTitle()),
          if (titleValue != null) Text(titleValue, style: titleValueStyle),
          if (onInfoClick != null) _buildInfoIcon()
        ],
      ),
      if (description != null) ...<Widget>[
        const SizedBox(height: 16),
        Container(
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

  Widget _buildHeaderTitle() {
    if (subtitle == null || image == null) {
      return Text(title, style: titleTextStyle);
    }

    const iconSize = 40.0;

    return Row(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: ColorRes.lightGrey,
            borderRadius: BorderRadius.circular(iconSize / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image?.startsWith('https://') == true
                ? CachedNetworkImage(imageUrl: image)
                : Center(
                    child: SizedBox(
                      height: 26,
                      width: 26,
                      child: SvgPicture.asset(image),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleTextStyle),
              Text(
                subtitle,
                style: Styles.bodyBlack.copyWith(
                  fontSize: 13,
                  color: ColorRes.greyCog,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoIcon() {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(left: 12),
      child: IconButton(
        padding: const EdgeInsets.all(8),
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
