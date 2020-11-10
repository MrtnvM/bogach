/// <reference types="@types/jest"/>

import produce from 'immer';
import { mock, instance, when, verify, anything, capture, reset } from 'ts-mockito';
import { GameProvider } from '../../providers/game_provider';
import { GameService } from './game_service';
import { TestData } from './game_service.multiplayer.spec.utils';
import { GameLevelsProvider } from '../../providers/game_levels_provider';
import { UserProvider } from '../../providers/user_provider';
import { TimerProvider } from '../../providers/timer_provider';
import { GameContext } from '../../models/domain/game/game_context';

describe('Game Service - Multiplayer game', () => {
  const mockGameProvider = mock(GameProvider);
  const mockGameLevelsProvider = mock(GameLevelsProvider);
  const mockUserProvider = mock(UserProvider);
  const mockTimerProvider = mock(TimerProvider);

  let gameService: GameService;

  beforeEach(() => {
    reset(mockGameProvider);
    reset(mockGameLevelsProvider);
    reset(mockUserProvider);
    reset(mockTimerProvider);

    gameService = new GameService(
      instance(mockGameProvider),
      instance(mockGameLevelsProvider),
      instance(mockUserProvider),
      instance(mockTimerProvider)
    );
  });

  test('Successfully start timer on creating game', async () => {
    const moveStartDateInUTC = new Date().toISOString();
    const game = produce(TestData.game, (draft) => {
      draft.state.moveStartDateInUTC = moveStartDateInUTC;
    });

    const templateId = 'template1';
    const participants = ['user1', 'user2'];

    when(mockGameProvider.createGame(templateId, participants)).thenResolve(game);

    await gameService.createNewGame(templateId, participants);
    const [timerParams] = capture(mockTimerProvider.scheduleTimer).last();

    expect(timerParams).toEqual({
      startDateInUTC: moveStartDateInUTC,
      gameId: game.id,
      monthNumber: 1,
    });
  });

  test('Successfully start timer when players completed move', async () => {
    const { user1, user2, gameId, lastEventId, lastEventPlayerAction } = TestData;

    const now = new Date();
    const game = produce(TestData.gameWithNotCompletedMonthForFirstPlayer, (draft) => {
      draft.state.moveStartDateInUTC = now.toISOString();
    });

    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameContext: GameContext = { userId: user1, gameId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    const [newGame] = capture(mockGameProvider.updateGame).last();
    const [timerParams] = capture(mockTimerProvider.scheduleTimer).last();

    const newMoveStartDate = new Date(newGame.state.moveStartDateInUTC);
    expect(newMoveStartDate.getTime()).toBeGreaterThan(now.getTime());

    expect(newGame.state.monthNumber).toEqual(2);
    expect(newGame.participants[user1].progress.currentEventIndex).toEqual(1);
    expect(newGame.participants[user1].progress.status).toEqual('month_result');
    expect(newGame.participants[user2].progress.currentEventIndex).toEqual(1);
    expect(newGame.participants[user2].progress.status).toEqual('month_result');

    expect(timerParams).toEqual({
      startDateInUTC: newMoveStartDate.toISOString(),
      gameId: game.id,
      monthNumber: 2,
    });
  });

  test('Can not complete month already completed game', async () => {
    const { gameId, game } = TestData;

    when(mockGameProvider.getGame(gameId)).thenResolve(
      produce(game, (draft) => {
        draft.state.gameStatus = 'game_over';
      })
    );

    await gameService.completeMonth(gameId, 1);
    verify(mockGameProvider.updateGame(anything())).never();
  });

  test('Can not complete already completed month', async () => {
    const { gameId, gameWithNotCompletedMonthForFirstPlayer } = TestData;

    when(mockGameProvider.getGame(gameId)).thenResolve(
      produce(gameWithNotCompletedMonthForFirstPlayer, (draft) => {
        draft.state.monthNumber = 3;
      })
    );

    await gameService.completeMonth(gameId, 2);
    verify(mockGameProvider.updateGame(anything())).never();
  });

  test('Can not complete future month', async () => {
    const { gameId, gameWhenOnlyFirstPlayerStartedNewMonth } = TestData;

    when(mockGameProvider.getGame(gameId)).thenResolve(gameWhenOnlyFirstPlayerStartedNewMonth);

    await gameService.completeMonth(gameId, 3);
    verify(mockGameProvider.updateGame(anything())).never();
  });

  test('Successfully complete month', async () => {
    const { gameId, gameWhenOnlyFirstPlayerStartedNewMonth } = TestData;

    when(mockGameProvider.getGame(gameId)).thenResolve(gameWhenOnlyFirstPlayerStartedNewMonth);

    await gameService.completeMonth(gameId, 2);
    // Also checking that one more call does not breaking the logic
    await gameService.completeMonth(gameId, 2);

    verify(mockGameProvider.updateGame(anything())).twice();

    const [newGame] = capture(mockGameProvider.updateGame).last();
    const [timerParams] = capture(mockTimerProvider.scheduleTimer).last();

    expect(newGame.state.monthNumber).toEqual(3);
    expect(
      newGame.participantsIds.map(
        (id) => newGame.participants[id].progress.currentMonthForParticipant
      )
    ).toEqual([2, 2]);

    expect(timerParams).toEqual({
      startDateInUTC: newGame.state.moveStartDateInUTC,
      gameId: gameWhenOnlyFirstPlayerStartedNewMonth.id,
      monthNumber: 3,
    });
  });

  test('When timer stopped after month without participants actions, it should be started on any player action', async () => {
    const { gameId, user1, gameWithNotStartedMonthByParticipants } = TestData;

    const minuteAndOneSecondInMs = 61 * 1000;
    const moveStartDate = new Date(new Date().getTime() - minuteAndOneSecondInMs);

    const game = produce(gameWithNotStartedMonthByParticipants, (draft) => {
      draft.state.moveStartDateInUTC = moveStartDate.toISOString();
    });

    when(mockGameProvider.getGame(game.id)).thenResolve(game);

    const gameContext: GameContext = { userId: user1, gameId };
    await gameService.startNewMonth(gameContext);

    const [newGame] = capture(mockGameProvider.updateGameWithoutParticipants).last();
    const [timerParams] = capture(mockTimerProvider.scheduleTimer).last();

    expect(newGame.state.monthNumber).toEqual(2);
    expect(new Date(newGame.state.moveStartDateInUTC).getTime()).toBeGreaterThan(
      moveStartDate.getTime()
    );

    expect(timerParams).toEqual({
      startDateInUTC: newGame.state.moveStartDateInUTC,
      gameId: game.id,
      monthNumber: 2,
    });
  });
});
