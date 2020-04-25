import 'package:cash_flow/models/state/account.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:uikit/uikit.dart';

class AccountBarBuilder extends UiKitBuilder {
  @override
  Type get componentType => AccountBar;

  @override
  void buildComponentStates() {
    build(
      'Account bar',
      AccountBar(
        account: Account(cash: 15000, cashFlow: 10000, credit: 5000),
      ),
    );
  }
}
