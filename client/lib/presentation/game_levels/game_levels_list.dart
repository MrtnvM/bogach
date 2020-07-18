import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class GameLevelList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final gameLevels = StoreList<GameLevel>([
      GameLevel(
        name: 'Кальянщик',
        icon:
            'https://st2.depositphotos.com/1504872/8305/v/450/depositphotos_83059322-stock-illustration-%D0%BA%D0%B0%D0%BB%D1%8C%D1%8F%D0%BD-%D1%8D%D1%81%D0%BA%D0%B8%D0%B7-%D0%B8%D0%BB%D0%BB%D1%8E%D1%81%D1%82%D1%80%D0%B0%D1%86%D0%B8%D1%8F.jpg',
      ),
      GameLevel(
        name: 'Продавец',
        icon:
            'https://thumbs.dreamstime.com/b/%D0%B7%D0%BD%D0%B0%D1%87%D0%BE%D0%BA-%D0%BA%D0%B0%D1%81%D1%81%D1%8B-%D0%B2-%D1%81%D1%82%D0%B8-%D0%B5-%D0%BF-%D0%B0%D0%BD%D0%B0-%D0%B8%D0%B7%D0%BE-%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D0%B9-%D0%BD%D0%B0-%D0%B1%D0%B5-%D0%BE%D0%B9-%D0%BF%D1%80%D0%B5-%D0%BF%D0%BE%D1%81%D1%8B-%D0%BA%D0%B5-83949376.jpg',
      ),
    ]);

    return Loadable(
      isLoading: false,
      backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
      child: LoadableList<GameLevel>(
        viewModel: LoadableListViewModel(
          items: gameLevels,
          itemBuilder: (i) => GameLevelItem(
            gameLevel: gameLevels.items[i],
            onLevelSelected: (level) => print('Selected level: ${level.name}'),
          ),
          loadListRequestState: RefreshableRequestState.idle,
          loadList: () => null,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
