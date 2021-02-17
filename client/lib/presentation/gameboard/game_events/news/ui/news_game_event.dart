import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/news/models/news_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/news/ui/news_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewsGameEvent extends HookWidget {
  const NewsGameEvent(this.event);

  final GameEvent event;

  NewsEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useNewsPlayerActionHandler(event: event);

    return Column(
      children: <Widget>[
        InfoTable(
          title: event.name,
          description: event.description,
          withShadow: false,
          rows: <Widget>[
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(eventData.imageUrl, fit: BoxFit.cover),
            ),
          ],
        ),
        const SizedBox(height: 28),
        PlayerActionBar(
          confirm: () {
            sendPlayerAction();
            AnalyticsSender.newsEvent();
          },
        ),
      ],
    );
  }
}
