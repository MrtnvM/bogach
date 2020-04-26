import 'package:cash_flow/models/state/game/account/account.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountBar extends StatelessWidget {
  const AccountBar({
    @required this.account,
  }) : assert(account != null);

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      color: ColorRes.gallery,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _buildItem(
              context,
              title: '${Strings.cashFlow}:',
              value: account.cashFlow,
            ),
          ),
          Expanded(
            child: _buildItem(
              context,
              title: '${Strings.cash}:',
              value: account.cash,
            ),
          ),
          Expanded(
            child: _buildItem(
              context,
              title: '${Strings.credit}:',
              value: account.credit,
            ),
          ),
        ],
      ),
    );
  }

  Column _buildItem(BuildContext context, {String title, double value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontWeight: FontWeight.w300),
        ),
        const Spacer(),
        Text(
          value.toPrice(),
          style: DefaultTextStyle.of(context).style.copyWith(
                color: ColorRes.darkBlue.withAlpha(230),
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
