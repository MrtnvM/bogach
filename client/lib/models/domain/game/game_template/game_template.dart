import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

import '../account/account.dart';
import '../target/target.dart';

class GameTemplate implements StoreListItem {
  const GameTemplate({
    required this.id,
    required this.name,
    required this.icon,
    required this.accountState,
    required this.target,
    this.image,
  });

  @override
  final String id;
  final String name;
  final String icon;
  final Account accountState;
  final Target target;
  final String? image;

  String getDescription() {
    final targetTitle = mapTargetTypeToString(target.type).toLowerCase();
    final targetValue = target.value.round().toPrice();
    final description = '${Strings.reach} $targetTitle '
        '${Strings.wordIn} $targetValue';

    return description;
  }
}
