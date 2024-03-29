import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/purchases/quests_purchase_page.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/widgets/containers/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestsBadge extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questsCount = useGlobalState((s) => s.newGame.quests.items.length);
    final user = useCurrentUser();
    final currentIndex = user?.currentQuestIndex ?? 0;

    return Badge(
      title: '$currentIndex / ${questsCount == 0 ? '-' : questsCount}',
      imageAsset: Images.questsBadge,
      onTap: () {
        if (user?.purchaseProfile?.isQuestsAvailable == false) {
          appRouter.goTo(const QuestsPurchasePage());
        }
      },
    );
  }
}
