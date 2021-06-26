import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game/type/game_type.dart';
import 'package:cash_flow/models/domain/game/game_config/game_config.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event_type.dart';
import 'package:cash_flow/models/domain/game/participant/participant.dart';
import 'package:cash_flow/models/domain/game/participant/participant_progress.dart';
import 'package:cash_flow/models/domain/game/possession_state/possession_state.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const TUTORIAL_GAME_ID = 'tutorial_game';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key, required this.gameId}) : super(key: key);

  final String gameId;

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late Store<AppState> store;

  final gameboardKey = GlobalKey();
  final gameId = TUTORIAL_GAME_ID;

  @override
  void initState() {
    super.initState();

    const userId = 'user1';

    store = Store(
      initialState: AppState.initial().rebuild((s) {
        s.profile.currentUser = UserProfile.withName(
          userId: userId,
          fullName: Strings.mascotName,
          avatarUrl: Images.bogachAvatarUrl,
        );

        s.game.activeGameStates![gameId] = ActiveGameState.gameEvent(
          eventIndex: 0,
          sendingEventIndex: -1,
        );

        s.game.games![gameId] = Game(
          id: gameId,
          name: Strings.tutorialQuestName,
          type: GameType.singleplayer(),
          state: CurrentGameState(
            gameStatus: GameStatus.playersMove,
            moveStartDateInUTC: DateTime.now(),
            monthNumber: 1,
            winners: [],
          ),
          participantsIds: [userId],
          participants: {
            userId: Participant(
              id: userId,
              progress: ParticipantProgress(
                currentEventIndex: 0,
                currentMonthForParticipant: 1,
                status: ParticipantProgressStatus.playerMove,
                monthResults: [],
                progress: 0.1,
              ),
              possessionState: PossessionState(
                incomes: [],
                expenses: [],
                assets: [],
                liabilities: [],
              ),
              account: Account(cashFlow: 10000, cash: 20000, credit: 5000),
            )
          },
          target: Target(type: TargetType.cash, value: 1000000),
          currentEvents: [
            GameEvent(
              id: 'event1',
              name: Strings.tutorialDebentureExample,
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
          config: GameConfig(
            level: 'level1',
            monthLimit: 7,
            initialCash: 1000,
            gameTemplateId: '',
          ),
        );
      }),
    );

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      final gameboardContext = gameboardKey.currentContext!;
      final gameTutorial = GameboardTutorialWidget.of(gameboardContext)!;

      gameTutorial.showTutorial(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: GameboardTutorialWidget(
        gameId: widget.gameId,
        child: GameBoard(key: gameboardKey, gameId: gameId),
      ),
    );
  }
}
