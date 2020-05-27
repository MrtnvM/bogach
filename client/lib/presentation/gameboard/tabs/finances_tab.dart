import 'package:cash_flow/presentation/gameboard/possessions/assets_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/expenses_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/incomes_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/liabilities_list.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/container_with_header_image/container_with_header_image.dart';
import 'package:flutter/material.dart';

class FinancesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContainerWithHeaderImage(
      navBarTitle: Strings.financesTabTitle,
      children: [
        _buildList(IncomesList()),
        _buildList(ExpensesList()),
        _buildList(AssetsList()),
        _buildList(LiabilitiesList()),
      ],
    );
  }

  Widget _buildList(Widget listWidget) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: listWidget,
    );
  }
}
