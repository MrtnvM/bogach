import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:uikit/uikit.dart';

class ActionBarBuilder extends UiKitBuilder {
  @override
  Type get componentType => PlayerActionBar;

  @override
  void buildComponentStates() {
    build(
        'Three buttons',
        PlayerActionBar(
          takeLoan: () {},
          confirm: () {},
          skip: () {},
        ));
    build(
      'Two buttons',
      PlayerActionBar(
        confirm: () {},
        skip: () {},
      ),
    );
    build(
      'One button',
      PlayerActionBar(
        confirm: () {},
      ),
    );
  }
}
