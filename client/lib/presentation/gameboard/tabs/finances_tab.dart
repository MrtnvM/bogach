import 'package:cash_flow/presentation/gameboard/possessions/assets_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/expenses_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/incomes_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/liabilities_list.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/resources/colors.dart';

class FinancesTab extends StatelessWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    const imageAspectRatio = 2.03;
    final imageHeight = screenWidth / imageAspectRatio;
    final contentOffset = imageHeight * 0.76;

    return Stack(
      children: <Widget>[
        _buildHeaderImage(imageHeight),
        ListView(
          controller: scrollController,
          padding: EdgeInsets.only(top: contentOffset),
          children: <Widget>[
            _buildList(IncomesList()),
            _buildList(ExpensesList()),
            _buildList(AssetsList()),
            _buildList(LiabilitiesList()),
            const SizedBox(height: 16),
          ],
        ),
        NavigationBar(
          title: Strings.financesTabTitle,
          scrollController: scrollController,
        ),
      ],
    );
  }

  Widget _buildHeaderImage(double imageHeight) {
    return Container(
      color: ColorRes.primaryBackgroundColor,
      height: imageHeight,
      alignment: Alignment.bottomCenter,
      child: const Image(image: AssetImage(Images.money)),
    );
  }

  Widget _buildList(Widget listWidget) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: listWidget,
    );
  }
}
