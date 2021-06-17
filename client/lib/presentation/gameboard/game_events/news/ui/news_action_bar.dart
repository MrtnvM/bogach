import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/news/models/news_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/news/ui/news_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewsGameActionBar extends HookWidget {
  const NewsGameActionBar({Key? key, required this.event}) : super(key: key);

  final GameEvent event;

  NewsEventData get eventData => event.data as NewsEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useNewsPlayerActionHandler(event: event);

    return PlayerActionBar(
      confirm: () {
        sendPlayerAction();
        AnalyticsSender.newsEvent();
      },
    );
  }
}
