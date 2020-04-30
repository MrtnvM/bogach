/// <reference types="@types/jest"/>

import { GameProvider } from '../../providers/game_provider';
import { mock, instance, reset, when, capture } from 'ts-mockito';
import { GameEntity } from '../../models/domain/game/game';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { DebenturePriceChangedHandler } from './debenture_price_changed_handler';
import { stubs, utils } from './debenture_price_changed_handler.spec.utils';
import produce from 'immer';

describe('Debenture price changed event handler', () => {
  const { eventId, gameId, userId, context, game, debenture1, initialCash } = stubs;
  const mockGameProvider = mock(GameProvider);

  beforeEach(() => {
    GameEntity.validate(game);
    reset(mockGameProvider);
  });

  test('Successfully bought new debenture', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const event = utils.debenturePriceChangedEvent({
      currentPrice: 1100,
      profitabilityPercent: 10,
      nominal: 1000,
      availableCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'buy',
      count: 1,
    });

    await handler.handle(event, action, context);

    const newDebentureAsset: DebentureAsset = {
      name: 'DebentureName',
      type: 'debenture',
      averagePrice: 1100,
      profitabilityPercent: 10,
      nominal: 1000,
      count: 1,
    };

    const expectedGame = produce(game, (draft) => {
      draft.possessions[userId].assets.push(newDebentureAsset);
      draft.accounts[userId].cash = initialCash - 1100;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing debenture on buy', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const currentPrice = 1200;
    const availableCount = 20;
    const event = utils.debentureOFZPriceChangedEvent(currentPrice, availableCount);

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'buy',
      count: 6,
    });

    await handler.handle(event, action, context);

    const newDebentureAsset = produce(debenture1, (draft) => {
      draft.count = 10;
      draft.averagePrice = 1160;
    });

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex(
        (d) => d.id === newDebentureAsset.id
      );

      draft.possessions[userId].assets[index] = newDebentureAsset;
      draft.accounts[userId].cash = initialCash - 7200;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing debenture on sell', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const currentPrice = 1100;
    const availableCount = 4;
    const event = utils.debentureOFZPriceChangedEvent(currentPrice, availableCount);

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 3,
    });

    await handler.handle(event, action, context);

    const newDebentureAsset = produce(debenture1, (draft) => {
      draft.count = 1;
    });

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex(
        (d) => d.id === newDebentureAsset.id
      );

      draft.possessions[userId].assets[index] = newDebentureAsset;
      draft.accounts[userId].cash = initialCash + 3300;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully remove debenture if all is sold', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const currentPrice = 1100;
    const availableCount = 4;
    const event = utils.debentureOFZPriceChangedEvent(currentPrice, availableCount);

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 4,
    });

    await handler.handle(event, action, context);

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex((d) => d.id === debenture1.id);

      draft.possessions[userId].assets.splice(index, 1);
      draft.accounts[userId].cash = initialCash + 4400;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cannot sell more debentures than already have', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const event = utils.debenturePriceChangedEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      availableCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 6,
    });

    try {
      await handler.handle(event, action, context);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Not enough debentures in portfolio'));
    }
  });

  test('Cannot sell more debentures than in action have', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const event = utils.debenturePriceChangedEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      availableCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 11,
    });

    try {
      await handler.handle(event, action, context);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Not enough debentures available'));
    }
  });

  test('Cannot buy more debentures than in action have', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const event = utils.debenturePriceChangedEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      availableCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'buy',
      count: 11,
    });

    try {
      await handler.handle(event, action, context);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Not enough debentures available'));
    }
  });
});
