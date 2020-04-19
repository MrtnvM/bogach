/// <reference types="@types/jest"/>

import { GameProvider } from '../../providers/game_provider';
import { mock, instance, reset, when, capture } from 'ts-mockito';
import { GameEntity } from '../../models/domain/game/game';
import { Strings } from '../../resources/strings';
import produce from 'immer';
import { stubs, utils } from './stock_price_changed_handler.spec.utils';
import { StockPriceChangedHandler } from './stock_price_changed_handler';
import { StockAsset } from '../../models/domain/assets/stock_asset';

describe('Stock price changed event handler', () => {
  const { eventId, gameId, userId, context, game, stock1, initialCash } = stubs;
  const mockGameProvider = mock(GameProvider);

  beforeEach(() => {
    GameEntity.validate(game);
    reset(mockGameProvider);
  });

  test('Successfully bought new stock', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new StockPriceChangedHandler(gameProvider);

    const event = utils.stockPriceChangedEvent({
      currentPrice: 100,
      fairPrice: 120,
      maxCount: 10,
    });

    const action = utils.stockPriceChangedPlayerAction({
      eventId,
      action: 'buy',
      count: 1,
    });

    await handler.handle(event, action, context);

    const newStockAsset: StockAsset = {
      name: Strings.stocks(),
      type: 'stock',
      currentPrice: 100,
      averagePrice: 120,
      fairPrice: 120,
      countInPortfolio: 1,
    };

    const expectedGame = produce(game, (draft) => {
      draft.possessions[userId].assets.push(newStockAsset);
      draft.accounts[userId].cash = initialCash - 100;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing stock on buy', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new StockPriceChangedHandler(gameProvider);

    const currentPrice = 130;
    const maxCount = 10;
    const event = utils.stockSberbankPriceChangedEvent(currentPrice, maxCount);

    const action = utils.stockPriceChangedPlayerAction({
      eventId,
      action: 'buy',
      count: 5,
    });

    await handler.handle(event, action, context);

    const newStockAsset = produce(stock1, (draft) => {
      draft.countInPortfolio = 10;
      draft.averagePrice = 125;
    });

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex((d) => d.id === newStockAsset.id);

      draft.possessions[userId].assets[index] = newStockAsset;
      draft.accounts[userId].cash = initialCash - 1250;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing stock on sell', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new StockPriceChangedHandler(gameProvider);

    const currentPrice = 150;
    const maxCount = 10;
    const event = utils.stockSberbankPriceChangedEvent(currentPrice, maxCount);

    const action = utils.stockPriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 3,
    });

    await handler.handle(event, action, context);

    const newDebentureAsset = produce(stock1, (draft) => {
      draft.countInPortfolio = 2;
    });

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex(
        (d) => d.id === newDebentureAsset.id
      );

      draft.possessions[userId].assets[index] = newDebentureAsset;
      draft.accounts[userId].cash = initialCash + 450;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully remove stock if all is sold', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new StockPriceChangedHandler(gameProvider);

    const currentPrice = 140;
    const maxCount = 10;
    const event = utils.stockSberbankPriceChangedEvent(currentPrice, maxCount);

    const action = utils.stockPriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 5,
    });

    await handler.handle(event, action, context);

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex((d) => d.id === stock1.id);

      draft.possessions[userId].assets.splice(index, 1);
      draft.accounts[userId].cash = initialCash + 700;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cannot sell more debentures than already have', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new StockPriceChangedHandler(gameProvider);

    const currentPrice = 140;
    const maxCount = 10;
    const event = utils.stockSberbankPriceChangedEvent(currentPrice, maxCount);

    const action = utils.stockPriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 6,
    });

    try {
      await handler.handle(event, action, context);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Not enough stocks'));
    }
  });
});
