import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_config/game_config.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event_type.dart';
import 'package:cash_flow/models/domain/game/possession_state/possession_state.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  Store<AppState> store;

  final gameboardKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    const userId = 'user1';
    const boagachAvatarUrl = 'https://firebasestorage.googleapis.com/v0/b/'
        'bogach-production.appspot.com/o/avatar%2Fbogach128.png?'
        'alt=media&token=5ff3572d-352c-46f7-b09b-871b6086a11b';

    store = Store(
      initialState: AppState.initial().rebuild((s) {
        s.profile.currentUser = UserProfile(
          userId: userId,
          fullName: 'Богач Бородач',
          avatarUrl: boagachAvatarUrl,
        );

        s.game.activeGameState = ActiveGameState.gameEvent(
          eventIndex: 0,
          sendingEventIndex: -1,
        );

        s.game.currentGame = Game(
          id: 'game1',
          name: 'Черный бумер',
          type: GameType.singleplayer,
          state: CurrentGameState(
            gameStatus: GameStatus.playersMove,
            moveStartDateInUTC: DateTime.now(),
            monthNumber: 1,
            participantsProgress: {
              userId: ParticipantProgress(
                currentEventIndex: 0,
                currentMonthForParticipant: 1,
                status: ParticipantProgressStatus.playerMove,
                monthResults: {},
                progress: 0.1,
              ),
            },
            winners: {},
          ),
          participants: [userId],
          possessionState: {
            userId: PossessionState(
              incomes: [],
              expenses: [],
              assets: [],
              liabilities: [],
            ),
          },
          accounts: {
            userId: Account(cashFlow: 10000, cash: 20000, credit: 5000)
          },
          target: Target(type: TargetType.cash, value: 1000000),
          currentEvents: [
            GameEvent(
              id: 'event1',
              name: 'ОФЗ 29006',
              description: '',
              type: GameEventType.debenture(),
              data: DebentureEventData(
                currentPrice: 900,
                nominal: 1000,
                profitabilityPercent: 1.3,
                availableCount: 100,
              ),
            ),
          ],
          config: GameConfig(level: 'level1', monthLimit: 7),
        );
      }),
    );

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      final gameboardContext = gameboardKey.currentContext;
      final gameTutorial = GameboardTutorialWidget.of(gameboardContext);

      gameTutorial.showTutorial(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: GameboardTutorialWidget(
        child: GameBoard(key: gameboardKey),
      ),
    );
  }
}
