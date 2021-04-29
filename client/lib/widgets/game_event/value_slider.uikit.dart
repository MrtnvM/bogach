import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/widgets/game_event/value_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_uikit/dash_kit_uikit.dart';

class ValueSliderBuilder extends UiKitBuilder {
  @override
  Type get componentType => ValueSlider;

  @override
  void buildComponentStates() {
    build('Value Slider', const _ValueSliderExample());
  }
}

class _ValueSliderExample extends HookWidget {
  const _ValueSliderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = useState(0);

    return ValueSlider(
      currentPrice: 100,
      currentAction: const BuySellAction.sell(),
      selectedCount: count.value,
      maxCount: 100,
      minCount: 1,
      onCountChanged: (c) {
        count.value = c;
        print(c);
      },
    );
  }
}
