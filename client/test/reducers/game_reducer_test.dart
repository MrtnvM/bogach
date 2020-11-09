import 'package:cash_flow/features/game/actions/on_game_state_changed_action.dart';
import 'package:cash_flow/models/domain/game/participant/participant.dart';
import 'package:cash_flow/models/domain/game/participant/participant_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const currentUser = 'current_user';
  const anotherUser1 = 'another_user_1';
  const anotherUser2 = 'another_user_2';
  const anotherUser3 = 'another_user_3';
  const anotherUser4 = 'another_user_4';

  test('Should not wait participants that already reach month result', () {
    final participantsProgress = {
      currentUser: Participant(
        id: currentUser,
        progress: ParticipantProgress(
          currentEventIndex: 0,
          status: ParticipantProgressStatus.playerMove,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser1: Participant(
        id: anotherUser1,
        progress: ParticipantProgress(
          currentEventIndex: 5,
          status: ParticipantProgressStatus.monthResult,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
    };

    final participantsForWaiting = getParticipantIdsForWaiting(
      currentUser,
      participantsProgress,
    );

    expect(participantsForWaiting, []);
  });

  test('Should wait participants that does not reach month result', () {
    final participants = {
      currentUser: Participant(
        id: currentUser,
        progress: ParticipantProgress(
          currentEventIndex: 5,
          status: ParticipantProgressStatus.monthResult,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser1: Participant(
        id: anotherUser1,
        progress: ParticipantProgress(
          currentEventIndex: 4,
          status: ParticipantProgressStatus.playerMove,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
    };

    final participantsForWaiting = getParticipantIdsForWaiting(
      currentUser,
      participants,
    );

    expect(participantsForWaiting, [anotherUser1]);
  });

  test('Should also wait participants that does not reach new month', () {
    final participantsProgress = {
      currentUser: Participant(
        id: currentUser,
        progress: ParticipantProgress(
          currentEventIndex: 5,
          status: ParticipantProgressStatus.monthResult,
          currentMonthForParticipant: 2,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser1: Participant(
        id: anotherUser1,
        progress: ParticipantProgress(
          currentEventIndex: 4,
          status: ParticipantProgressStatus.playerMove,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser2: Participant(
        id: anotherUser2,
        progress: ParticipantProgress(
          currentEventIndex: 5,
          status: ParticipantProgressStatus.monthResult,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser3: Participant(
        id: anotherUser3,
        progress: ParticipantProgress(
          currentEventIndex: 2,
          status: ParticipantProgressStatus.playerMove,
          currentMonthForParticipant: 2,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser4: Participant(
        id: anotherUser4,
        progress: ParticipantProgress(
          currentEventIndex: 5,
          status: ParticipantProgressStatus.monthResult,
          currentMonthForParticipant: 2,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
    };

    final participantsForWaiting = getParticipantIdsForWaiting(
      currentUser,
      participantsProgress,
    );

    expect(participantsForWaiting, [anotherUser1, anotherUser2, anotherUser3]);
  });

  test('Should not wait participants that already reach new month', () {
    final participantsProgress = {
      currentUser: Participant(
        id: currentUser,
        progress: ParticipantProgress(
          currentEventIndex: 5,
          status: ParticipantProgressStatus.monthResult,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser1: Participant(
        id: anotherUser1,
        progress: ParticipantProgress(
          currentEventIndex: 4,
          status: ParticipantProgressStatus.playerMove,
          currentMonthForParticipant: 2,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
      anotherUser2: Participant(
        id: anotherUser2,
        progress: ParticipantProgress(
          currentEventIndex: 5,
          status: ParticipantProgressStatus.monthResult,
          currentMonthForParticipant: 1,
          monthResults: [],
          progress: 0,
        ),
        possessionState: null,
        account: null,
      ),
    };

    final participantsForWaiting = getParticipantIdsForWaiting(
      currentUser,
      participantsProgress,
    );

    expect(participantsForWaiting, []);
  });
}
