/// <reference types="@types/jest"/>

import { GameEntity } from '../../../models/domain/game/game';
import { stubs, utils } from './business_buy_event_handler.spec.utils';
import produce from 'immer';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';
import { BusinessBuyEventHandler } from './business_buy_event_handler';
import { Liability, LiabilityEntity } from '../../../models/domain/liability';
import { BusinessBuyEvent } from './business_buy_event';
import { DomainErrors } from '../../../core/exceptions/domain/domain_errors';
import { mock, reset } from 'ts-mockito';
import { CreditHandler } from '../../common/credit_handler';

describe('Business buy event event handler', () => {
  const { eventId, userId, game, initialCash } = stubs;

  const mockCreditHandler = mock(CreditHandler);

  beforeEach(() => {
    GameEntity.validate(game);
    reset(mockCreditHandler);
  });

  test('Successfully bought new business', async () => {
    const handler = new BusinessBuyEventHandler(mockCreditHandler);

    const event = utils.businessOfferEvent({
      businessId: 'randomId',
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

    const newGame = await handler.handle(game, event, action, userId);

    const newBusinessAsset: BusinessAsset = {
      id: 'randomId',
      name: 'Торговая точка',
      type: 'business',
      buyPrice: 100_000,
      downPayment: 15_000,
      fairPrice: 90_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    };

    const newLiability: Liability = {
      id: 'randomId',
      name: 'Торговая точка',
      type: LiabilityEntity.TypeValues[1],
      monthlyPayment: 0,
      value: 85_000,
    };

    const expectedGame = produce(game, (draft) => {
      const participant = draft.participants[userId];

      participant.possessions.assets.push(newBusinessAsset);
      participant.account.cash = initialCash - 15_000;
      participant.possessions.liabilities.push(newLiability);
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cant buy two the same businesses', async () => {
    const handler = new BusinessBuyEventHandler(mockCreditHandler);

    const currentPrice = 120_000;
    const event = utils.dryCleaningBusinessOfferEvent(currentPrice);

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'buy',
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Should fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Cant buy two the same businesses'));
    }
  });

  test('Cant buy two the same businesses if liability present', async () => {
    const handler = new BusinessBuyEventHandler(mockCreditHandler);

    const newBusinessData: BusinessBuyEvent.Data = {
      businessId: 'existingLiabilityId',
      currentPrice: 100_000,
      fairPrice: 30_000,
      downPayment: 20_000,
      debt: 10_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    };
    const event: BusinessBuyEvent.Event = {
      id: eventId,
      name: 'Бизнес у которого совпадет долг',
      description: 'Description',
      type: BusinessBuyEvent.Type,
      data: newBusinessData,
    };

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'buy',
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Should fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(new Error('Cant buy business with two the same liabilities'));
    }
  });

  test('Can not handle sell action', async () => {
    const handler = new BusinessBuyEventHandler(mockCreditHandler);

    const currentPrice = 120_000;
    const event = utils.dryCleaningBusinessOfferEvent(currentPrice);

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'sell',
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Should fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(
        new Error(
          'Error action type when dispatching ' + 'sell' + ' in ' + BusinessBuyEventHandler.name
        )
      );
    }
  });

  test('Can not buy new business if not enough money', async () => {
    const handler = new BusinessBuyEventHandler(mockCreditHandler);

    const event = utils.businessOfferEvent({
      businessId: 'randomId',
      currentPrice: 130_000,
      fairPrice: 120_000,
      downPayment: 115_000,
      debt: 15_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    });

    const action = utils.businessOfferEventPlayerAction({
      eventId,
      action: 'buy',
    });

    try {
      await handler.handle(game, event, action, userId);
      throw new Error('Should fail on previous line');
    } catch (error) {
      expect(error).toStrictEqual(DomainErrors.notEnoughCash);
    }
  });
});
