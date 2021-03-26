/// <reference types="@types/jest"/>

import produce from 'immer';

import { GameEntity } from '../../../models/domain/game/game';
import { stubs, utils } from './business_sell_event_handler.spec.utils';
import { BusinessSellEventHandler } from './business_sell_event_handler';

describe('Business sell event handler', () => {
  const { eventId, userId, game, initialCash } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully remove existing business and liability on sell', async () => {
    const handler = new BusinessSellEventHandler();

    const currentPrice = 140_000;
    const event = utils.dryCleaningBusinessOfferEvent(currentPrice);

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'sell',
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const participant = draft.participants[userId];
      const { assets, liabilities } = participant.possessions;

      const businessAssetIndex = assets.findIndex((a) => a.id === event.data.businessId);
      assets.splice(businessAssetIndex, 1);

      const liabilityIndex = liabilities.findIndex((l) => l.id === event.data.businessId);
      liabilities.splice(liabilityIndex, 1);

      participant.account.cash = initialCash + 41_000;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully remove existing business and liability on sell with price less than debt', async () => {
    const handler = new BusinessSellEventHandler();

    const currentPrice = 110_000;
    const event = utils.carwashingBusinessSellEvent(currentPrice);

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'sell',
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const participant = draft.participants[userId];
      const { assets, liabilities } = participant.possessions;

      const businessAssetIndex = assets.findIndex((a) => a.id === event.data.businessId);
      assets.splice(businessAssetIndex, 1);

      const businessLiabilityIndex = liabilities.findIndex((l) => l.id === event.data.businessId);
      liabilities.splice(businessLiabilityIndex, 1);

      participant.account.cash = initialCash - 10_000;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cannot sell business if it not present', async () => {
    const handler = new BusinessSellEventHandler();

    const event = utils.businessOfferEvent({
      businessId: 'random id',
      currentPrice: 100_000,
    });

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'sell',
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Should fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Can not find business with id random id'));
    }
  });

  test('Cannot sell business if liability not present', async () => {
    const handler = new BusinessSellEventHandler();

    const event = utils.businessOfferEvent({
      businessId: 'id3',
      currentPrice: 100_000,
    });

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'sell',
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Should fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Can not find liability with id id3'));
    }
  });

  test('Cannot hold buy actions', async () => {
    const handler = new BusinessSellEventHandler();

    const event = utils.businessOfferEvent({
      businessId: 'random id',
      currentPrice: 100_000,
    });

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'buy',
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Should fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(
        new Error('Error action type when dispatching buy in ' + BusinessSellEventHandler.name)
      );
    }
  });
});
