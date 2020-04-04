/// <reference types="@types/jest"/>

import { GameProvider } from '../../providers/game_provider';
import { mock, instance, reset, when, capture } from 'ts-mockito';
import { GameEntity } from '../../models/domain/game/game';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { DebenturePriceChangedHandler } from './debenture_price_changed_handler';
import { Strings } from '../../resources/strings';
import { stubs, utils } from './debenture_price_changed_handler.spec.utils';

describe('Debenture price changed event handler', () => {
  const { eventId, gameId, context, game, debenture1 } = stubs;
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
      maxCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'buy',
      count: 1,
    });

    await handler.handle(event, action, context);

    const newDebentureAsset: DebentureAsset = {
      name: Strings.debetures(),
      type: 'debenture',
      currentPrice: 1100,
      profitabilityPercent: 10,
      nominal: 1000,
      count: 1,
    };

    const expectedGame = utils.gameWithNewAsset(newDebentureAsset);

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing debenture on buy', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const event = utils.debenturePriceChangedEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      maxCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'buy',
      count: 5,
    });

    await handler.handle(event, action, context);

    const newDebentureAsset: DebentureAsset = {
      ...debenture1,
      count: 9,
    };

    const expectedGame = utils.gameWithUpdatedAsset(newDebentureAsset);

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing debenture on sell', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const event = utils.debenturePriceChangedEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      maxCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 3,
    });

    await handler.handle(event, action, context);

    const newDebentureAsset: DebentureAsset = {
      ...debenture1,
      count: 1,
    };

    const expectedGame = utils.gameWithUpdatedAsset(newDebentureAsset);

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully remove debenture if all is sold', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new DebenturePriceChangedHandler(gameProvider);

    const event = utils.debenturePriceChangedEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      maxCount: 10,
    });

    const action = utils.debenturePriceChangedPlayerAction({
      eventId,
      action: 'sell',
      count: 4,
    });

    await handler.handle(event, action, context);

    const expectedGame = utils.gameWithoutAsset(debenture1.id as string);
    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });
});
