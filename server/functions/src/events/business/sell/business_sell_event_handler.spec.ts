/// <reference types="@types/jest"/>

import { GameProvider } from '../../../providers/game_provider';
import { mock, instance, reset, when, capture } from 'ts-mockito';
import { GameEntity } from '../../../models/domain/game/game';
import { stubs, utils } from './business_sell_event_handler.spec.utils';
import produce from 'immer';
import { BusinessOfferEventHandler } from './business_sell_event_handler';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';

describe('Debenture price changed event handler', () => {
  const { eventId, gameId, userId, context, game, business1, initialCash } = stubs;
  const mockGameProvider = mock(GameProvider);

  beforeEach(() => {
    GameEntity.validate(game);
    reset(mockGameProvider);
  });

  test('Successfully bought new business', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new BusinessOfferEventHandler(gameProvider);

    const event = utils.businessOfferEvent({
      currentPrice: 100_000,
      fairPrice: 90_000,
      downPayment: 15_000,
      debt: 85_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    });

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'buy',
    });

    await handler.handle(event, action, context);

    const newBusinessAsset: BusinessAsset = {
      name: 'Тест бизнес',
      type: 'business',
      buyPrice: 100_000,
      downPayment: 15_000,
      fairPrice: 90_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    };

    const expectedGame = produce(game, (draft) => {
      draft.possessions[userId].assets.push(newBusinessAsset);
      draft.accounts[userId].cash = initialCash - 15_000;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cant buy two the same businesses', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new BusinessOfferEventHandler(gameProvider);

    const currentPrice = 120_000;
    const event = utils.dryCleaningBusinessOfferEvent(currentPrice);

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'buy',
    });

    try {
      await handler.handle(event, action, context);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Cant buy two the same businesses'));
    }
  });

  test('Successfully remove existing business on sell', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new BusinessOfferEventHandler(gameProvider);

    const currentPrice = 120_000;
    const event = utils.dryCleaningBusinessOfferEvent(currentPrice);

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'sell',
    });

    await handler.handle(event, action, context);

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex((d) => d.id === business1.id);

      draft.possessions[userId].assets.splice(index, 1);
      draft.accounts[userId].cash = initialCash + 0;
    });

    const [newGame] = capture(mockGameProvider.updateGame).last();
    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cannot sell business if it not present', async () => {
    when(mockGameProvider.getGame(gameId)).thenResolve({ ...game });

    const gameProvider = instance(mockGameProvider);
    const handler = new BusinessOfferEventHandler(gameProvider);

    const event = utils.businessOfferEvent({
      currentPrice: 100_000,
      fairPrice: 90_000,
      downPayment: 15_000,
      debt: 85_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    });

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'sell',
    });

    try {
      await handler.handle(event, action, context);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Business was not found on assets'));
    }
  });
});
