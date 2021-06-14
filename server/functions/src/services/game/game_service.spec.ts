/// <reference types="@types/jest"/>

import produce from 'immer';
import { mock, instance, when, capture, verify, anything, reset } from 'ts-mockito';
import { GameProvider } from '../../providers/game_provider';
import { GameService } from './game_service';
import { GameContext } from '../../models/domain/game/game_context';
import { TestData } from './game_service.spec.utils';
import { GameLevelsProvider } from '../../providers/game_levels_provider';
import { UserProvider } from '../../providers/user_provider';
import { TimerProvider } from '../../providers/timer_provider';
import { ErrorRecorder } from '../../config';
import { PlayedGameInfo } from '../../models/domain/user/player_game_info';
import { nowInUtc } from '../../utils/datetime';

describe('Game Service - Singleplayer game', () => {
  const mockGameProvider = mock(GameProvider);
  const mockUserProvider = mock(UserProvider);
  const mockGameLevelsProvider = mock(GameLevelsProvider);
  const mockTimerProvider = mock(TimerProvider);

  let gameService: GameService;

  beforeEach(() => {
    reset(mockGameProvider);
    reset(mockUserProvider);
    reset(mockGameLevelsProvider);
    reset(mockTimerProvider);

    gameService = new GameService(
      instance(mockGameProvider),
      instance(mockGameLevelsProvider),
      instance(mockUserProvider),
      instance(mockTimerProvider)
    );

    const gameLevelsProvider = new GameLevelsProvider();
    when(mockGameLevelsProvider.getGameLevels()).thenReturn(gameLevelsProvider.getGameLevels());
  });

  test('Successfully handle not last game event', async () => {
    const { gameId, userId, game, firstEventId, firstEventPlayerAction, incomeEvent } = TestData;

    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(firstEventId, firstEventPlayerAction, gameContext);

    const expectedAccount = produce(game.participants[userId].account, (draft) => {
      draft.cash += incomeEvent.data.income;
    });

    const expectedGameState = produce(game.state, (draft) => {
      draft.winners = [{ userId, targetValue: 0.021, benchmark: 0 }];
    });

    const expectedParticipantState = produce(game.participants[userId].progress, (draft) => {
      draft.currentEventIndex = 1;
      draft.progress = 0.021;
    });

    const [newGame] = capture(mockGameProvider.updateGameForUser).last();

    expect(newGame.participants[userId].account).toStrictEqual(expectedAccount);
    expect(newGame.participants[userId].progress).toStrictEqual(expectedParticipantState);
    expect(newGame.participants[userId].possessions).toStrictEqual(
      game.participants[userId].possessions
    );
    expect(newGame.state).toStrictEqual(expectedGameState);
  });

  test('Successfully handle last game event', async () => {
    const { gameId, game, userId, lastEventId, lastEventPlayerAction, expenseEvent } = TestData;

    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    const expectedAccount = produce(game.participants[userId].account, (draft) => {
      draft.cash = draft.cash + draft.cashFlow - expenseEvent.data.expense;
    });

    const expectedParticipantState = produce(game.participants[userId].progress, (draft) => {
      draft.currentEventIndex = 1;
      draft.status = 'month_result';
      draft.progress = 0.029;
      draft.monthResults['1'] = {
        cash: 29_000,
        totalIncome: 10_000,
        totalExpense: 0,
        totalAssets: 0,
        totalLiabilities: 0,
      };
    });

    const expectedGameState = produce(game.state, (draft) => {
      draft.monthNumber += 1;
      draft.winners = [{ userId, targetValue: 0.029, benchmark: 0 }];
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();

    expect(newGame.participants[userId].account).toStrictEqual(expectedAccount);
    expect(newGame.participants[userId].progress).toStrictEqual(expectedParticipantState);
    expect(newGame.participants[userId].possessions).toStrictEqual(
      game.participants[userId].possessions
    );
    expect(newGame.state).toStrictEqual(expectedGameState);
    expect(newGame.currentEvents).not.toStrictEqual(game.currentEvents);
  });

  test('Successfully game over', async () => {
    const { gameId, userId, lastEventId, lastEventPlayerAction, expenseEvent } = TestData;
    const game = produce(TestData.game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = 999999;
    });

    when(mockGameProvider.getGame(gameId)).thenResolve(game);
    when(mockGameProvider.updateLevelStatistic(anything())).thenResolve({
      id: 'level1',
      statistic: new Map<string, number>(),
    });

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    const expectedAccount = produce(game.participants[userId].account, (draft) => {
      draft.cash = draft.cash + draft.cashFlow - expenseEvent.data.expense;
    });

    const expectedGameState = produce(game.state, (draft) => {
      draft.monthNumber += 1;
      draft.gameStatus = 'game_over';
      draft.winners = [{ userId, targetValue: 1.008999, benchmark: 0 }];
    });

    const expectedParticipantProgress = produce(game.participants[userId].progress, (draft) => {
      draft.currentEventIndex = 1;
      draft.status = 'month_result';
      draft.progress = 1.008999;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();

    expect(newGame.participants[userId].account).toStrictEqual(expectedAccount);
    expect(newGame.participants[userId].progress).toStrictEqual(expectedParticipantProgress);
    expect(newGame.participants[userId].possessions).toStrictEqual(
      game.participants[userId].possessions
    );
    expect(newGame.state).toStrictEqual(expectedGameState);
    expect(newGame.currentEvents).toStrictEqual(game.currentEvents);
  });

  test('Can not update completed game', async () => {
    const { gameId, userId, lastEventId, lastEventPlayerAction } = TestData;
    const game = produce(TestData.game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = 1_000_000;
      draft.state.gameStatus = 'game_over';
    });

    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    verify(mockGameProvider.updateGame(anything())).never();
  });

  test('Successfully removed completed singleplayer game', async () => {
    const { gameId, game, userId, lastEventId, lastEventPlayerAction } = TestData;

    const singleplayerGame = produce(game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = 1_100_000;
      draft.type = 'singleplayer';
      draft.config.level = null;
    });

    when(mockGameProvider.getGame(gameId)).thenResolve(singleplayerGame);
    when(mockGameProvider.updateLevelStatistic(anything())).thenResolve({
      id: 'level1',
      statistic: new Map<string, number>(),
    });

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    verify(mockUserProvider.removeGameFromLastGames(userId, gameId)).once();
  });

  test('Successfully increasing played multiplayer games counter', async () => {
    const { userId, getInitialProfile } = TestData;
    const initialProfile = getInitialProfile({
      boughtQuestsAccess: false,
      multiplayerGamePlayed: 0,
    });
    const gameCreationDate = nowInUtc();

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    await gameService.reduceMultiplayerGames([initialProfile.userId], 'gameId', gameCreationDate);

    const [newUserProfile] = capture(mockUserProvider.updateUserProfile).last();
    const expectedProfile = produce(initialProfile, (draft) => {
      const playedGames = draft.playedGames || {
        multiplayerGames: [],
      };
      playedGames.multiplayerGames = [];

      const playedGameInfo: PlayedGameInfo = {
        gameId: 'gameId',
        createdAt: gameCreationDate,
      };
      playedGames.multiplayerGames.push(playedGameInfo);

      draft.playedGames = playedGames;
    });
    expect(expectedProfile).toStrictEqual(newUserProfile);
  });

  test('Reduce zero multiplayer games', async () => {
    const { userId, getInitialProfile } = TestData;
    const initialProfile = getInitialProfile({
      boughtQuestsAccess: false,
      multiplayerGamePlayed: 0,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 0,
      },
    });

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    ErrorRecorder.isEnabled = false;

    await expect(
      gameService.reduceMultiplayerGames([initialProfile.userId], 'gameId', nowInUtc())
    ).rejects.toThrow(/.*multiplayerGamesCount can't be less then zero.*/);

    ErrorRecorder.isEnabled = true;
  });
});
