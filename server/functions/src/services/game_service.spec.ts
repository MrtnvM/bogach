/// <reference types="@types/jest"/>

import produce from 'immer';
import { mock, instance, when, capture, verify, anything } from 'ts-mockito';
import { GameProvider } from '../providers/game_provider';
import { GameService } from './game_service';
import { GameContext } from '../models/domain/game/game_context';
import { TestData } from './game_service.spec.utils';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { UserProvider } from '../providers/user_provider';
import { TimerProvider } from '../providers/timer_provider';

describe('Game Service - Singleplayer game', () => {
  test('Successfully handle not last game event', async () => {
    const { gameId, userId, game, firstEventId, firstEventPlayerAction } = TestData;

    const mockGameProvider = mock(GameProvider);
    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameProvider = instance(mockGameProvider);
    const gameLevelsProvider = instance(mock(GameLevelsProvider));
    const userProvider = instance(mock(UserProvider));
    const timerProvider = instance(mock(TimerProvider));
    const gameService = new GameService(
      gameProvider,
      gameLevelsProvider,
      userProvider,
      timerProvider
    );

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(firstEventId, firstEventPlayerAction, gameContext);

    const expectedAccounts = produce(game.accounts, (draft) => {
      const firstEventAssetCost = 1_100;
      draft[userId].cash -= firstEventAssetCost;
    });

    const expectedGameState = produce(game.state, (draft) => {
      draft.participantsProgress[userId].currentEventIndex = 1;
      draft.participantsProgress[userId].progress = 0.0189;
      draft.winners = { 0: userId };
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();

    expect(newGame.accounts).toStrictEqual(expectedAccounts);
    expect(newGame.state).toStrictEqual(expectedGameState);
    expect(newGame.possessions).not.toStrictEqual(game.possessions);
  });

  test('Successfully handle last game event', async () => {
    const { gameId, game, userId, lastEventId, lastEventPlayerAction } = TestData;

    const mockGameProvider = mock(GameProvider);
    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameProvider = instance(mockGameProvider);
    const gameLevelsProvider = instance(mock(GameLevelsProvider));
    const userProvider = instance(mock(UserProvider));
    const timerProvider = instance(mock(TimerProvider));
    const gameService = new GameService(
      gameProvider,
      gameLevelsProvider,
      userProvider,
      timerProvider
    );

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    const expectedAccounts = produce(game.accounts, (draft) => {
      const userAccount = draft[userId];
      const lastEventAssetCost = 900;
      const newCash = userAccount.cash + userAccount.cashFlow - lastEventAssetCost;
      draft[userId].cash = newCash;
    });

    const expectedGameState = produce(game.state, (draft) => {
      const participantProgress = draft.participantsProgress[userId];
      participantProgress.currentEventIndex = 1;
      participantProgress.status = 'month_result';
      participantProgress.progress = 0.0291;
      participantProgress.monthResults['1'] = {
        cash: 29_100,
        totalIncome: 10_005,
        totalExpense: 0,
        totalAssets: 900,
        totalLiabilities: 0,
      };

      draft.monthNumber += 1;
      draft.winners = { 0: userId };
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();

    expect(newGame.accounts).toStrictEqual(expectedAccounts);
    expect(newGame.state).toStrictEqual(expectedGameState);
    expect(newGame.currentEvents).not.toStrictEqual(game.currentEvents);
    expect(newGame.possessions).not.toStrictEqual(game.possessions);
  });

  test('Successfully game over', async () => {
    const { gameId, userId, lastEventId, lastEventPlayerAction } = TestData;
    const game = produce(TestData.game, (draft) => {
      draft.accounts[userId].cash = 999999;
    });

    const mockGameProvider = mock(GameProvider);
    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameProvider = instance(mockGameProvider);
    const gameLevelsProvider = new GameLevelsProvider();
    const userProvider = instance(mock(UserProvider));
    const timerProvider = instance(mock(TimerProvider));
    const gameService = new GameService(
      gameProvider,
      gameLevelsProvider,
      userProvider,
      timerProvider
    );

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    const expectedAccounts = produce(game.accounts, (draft) => {
      const userAccount = draft[userId];
      const lastEventAssetCost = 900;
      const newCash = userAccount.cash + userAccount.cashFlow - lastEventAssetCost;
      draft[userId].cash = newCash;
    });

    const expectedGameState = produce(game.state, (draft) => {
      const newCurrentEventIndex = 1;
      draft.participantsProgress[userId].currentEventIndex = newCurrentEventIndex;
      draft.participantsProgress[userId].status = 'month_result';
      draft.participantsProgress[userId].progress = 1.009099;
      draft.monthNumber += 1;
      draft.gameStatus = 'game_over';
      draft.winners = { 0: userId };
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();

    expect(newGame.accounts).toStrictEqual(expectedAccounts);
    expect(newGame.state).toStrictEqual(expectedGameState);
    expect(newGame.currentEvents).toStrictEqual(game.currentEvents);
    expect(newGame.possessions).not.toStrictEqual(game.possessions);
  });

  test('Can not update completed game', async () => {
    const { gameId, userId, lastEventId, lastEventPlayerAction } = TestData;
    const game = produce(TestData.game, (draft) => {
      draft.accounts[userId].cash = 1_000_000;
      draft.state.gameStatus = 'game_over';
    });

    const mockGameProvider = mock(GameProvider);
    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameProvider = instance(mockGameProvider);
    const gameLevelsProvider = instance(mock(GameLevelsProvider));
    const userProvider = instance(mock(UserProvider));
    const timerProvider = instance(mock(TimerProvider));
    const gameService = new GameService(
      gameProvider,
      gameLevelsProvider,
      userProvider,
      timerProvider
    );

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    verify(mockGameProvider.updateGame(anything())).never();
  });
});
