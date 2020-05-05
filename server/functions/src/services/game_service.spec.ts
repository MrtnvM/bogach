/// <reference types="@types/jest"/>

import { mock, instance, when, capture } from 'ts-mockito';
import { GameProvider } from '../providers/game_provider';
import { GameService } from './game_service';
import { GameContext } from '../models/domain/game/game_context';
import { TestData } from './game_service.spec.utils';
import produce from 'immer';

describe('Game Service - Singleplayer game', () => {
  test('Successfully handle not last game event', async () => {
    const { gameId, userId, game, firstEventId, firstEventPlayerAction } = TestData;

    const mockGameProvider: GameProvider = mock(GameProvider);
    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameProvider: GameProvider = instance(mockGameProvider);
    const gameService = new GameService(gameProvider);

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(firstEventId, firstEventPlayerAction, gameContext);

    const expectedAccounts = produce(game.accounts, (draft) => {
      const firstEventAssetCost = 1_100;
      draft[userId].cash -= firstEventAssetCost;
    });

    const expectedGameState = produce(game.state, (draft) => {
      const newCurrentEventIndex = 1;
      draft.participantProgress[userId] = newCurrentEventIndex;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();

    expect(newGame.accounts).toStrictEqual(expectedAccounts);
    expect(newGame.state).toStrictEqual(expectedGameState);
    expect(newGame.possessions).not.toStrictEqual(game.possessions);
  });

  test('Successfully handle last game event', async () => {
    const { gameId, userId, lastEventId, lastEventPlayerAction } = TestData;
    const game = produce(TestData.game, (draft) => {
      draft.state.participantProgress[userId] = draft.currentEvents.length - 1;
    });

    const mockGameProvider: GameProvider = mock(GameProvider);
    when(mockGameProvider.getGame(gameId)).thenResolve(game);

    const gameProvider: GameProvider = instance(mockGameProvider);
    const gameService = new GameService(gameProvider);

    const gameContext: GameContext = { gameId, userId };
    await gameService.handlePlayerAction(lastEventId, lastEventPlayerAction, gameContext);

    const expectedAccounts = produce(game.accounts, (draft) => {
      const userAccount = draft[userId];
      const lastEventAssetCost = 900;
      const newCash = userAccount.cash + userAccount.cashFlow - lastEventAssetCost;
      draft[userId].cash = newCash;
    });

    const expectedGameState = produce(game.state, (draft) => {
      const newCurrentEventIndex = 0;
      draft.participantProgress[userId] = newCurrentEventIndex;
      draft.monthNumber += 1;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();

    expect(newGame.accounts).toStrictEqual(expectedAccounts);
    expect(newGame.state).toStrictEqual(expectedGameState);
    expect(newGame.currentEvents).not.toStrictEqual(game.currentEvents);
    expect(newGame.possessions).not.toStrictEqual(game.possessions);
  });
});
