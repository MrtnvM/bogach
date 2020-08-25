/// <reference types="@types/jest"/>

import { GameEntity } from '../../models/domain/game/game';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { DebentureEventHandler } from './debenture_event_handler';
import { stubs, utils } from './debenture_event_handler.spec.utils';
import produce from 'immer';
import { DomainErrors } from '../../core/exceptions/domain/domain_errors';

describe('Debenture price changed event handler', () => {
  const { eventId, userId, game, debenture1, initialCash } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully bought new debenture', async () => {
    const handler = new DebentureEventHandler();

    const event = utils.debentureEvent({
      currentPrice: 1100,
      profitabilityPercent: 10,
      nominal: 1000,
      availableCount: 10,
    });

    const action = utils.debenturePlayerAction({
      eventId,
      action: 'buy',
      count: 1,
    });

    const newGame = await handler.handle(game, event, action, userId);

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

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing debenture on buy', async () => {
    const handler = new DebentureEventHandler();

    const currentPrice = 1200;
    const availableCount = 20;
    const event = utils.debentureOFZEvent(currentPrice, availableCount);

    const action = utils.debenturePlayerAction({
      eventId,
      action: 'buy',
      count: 6,
    });

    const newGame = await handler.handle(game, event, action, userId);

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

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully update existing debenture on sell', async () => {
    const handler = new DebentureEventHandler();

    const currentPrice = 1100;
    const availableCount = 4;
    const event = utils.debentureOFZEvent(currentPrice, availableCount);

    const action = utils.debenturePlayerAction({
      eventId,
      action: 'sell',
      count: 3,
    });

    const newGame = await handler.handle(game, event, action, userId);

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

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully remove debenture if all is sold', async () => {
    const handler = new DebentureEventHandler();

    const currentPrice = 1100;
    const availableCount = 4;
    const event = utils.debentureOFZEvent(currentPrice, availableCount);

    const action = utils.debenturePlayerAction({
      eventId,
      action: 'sell',
      count: 4,
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const index = draft.possessions[userId].assets.findIndex((d) => d.id === debenture1.id);

      draft.possessions[userId].assets.splice(index, 1);
      draft.accounts[userId].cash = initialCash + 4400;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cannot sell more debentures than already have', async () => {
    const handler = new DebentureEventHandler();

    const event = utils.debentureEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      availableCount: 10,
    });

    const action = utils.debenturePlayerAction({
      eventId,
      action: 'sell',
      count: 6,
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(DomainErrors.notEnoughDebenturesInPortfolio);
    }
  });

  test('Cannot sell more debentures than in action have', async () => {
    const handler = new DebentureEventHandler();

    const event = utils.debentureEvent({
      currentPrice: 1100,
      profitabilityPercent: 8,
      nominal: 1000,
      availableCount: 10,
    });

    const action = utils.debenturePlayerAction({
      eventId,
      action: 'sell',
      count: 11,
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Shoud fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(DomainErrors.notEnoughDebenturesDemandForSell);
    }
  });
});
