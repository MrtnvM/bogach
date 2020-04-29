import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/models/domain/game_template.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_item.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_list.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/widgets/texts/title_test.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class SingleGamePage extends StatelessWidget with ReduxComponent {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CashAppBar(
        title: const TitleText(Strings.chooseLevel),
        backgroundColor: ColorRes.darkBlue,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: ColorRes.darkBlue,
      child: TemplateGameList(),
    );
  }
}
