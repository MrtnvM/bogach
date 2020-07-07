/// <reference types="@types/jest"/>

import { GameEntity } from '../../../models/domain/game/game';
import produce from 'immer';
import { Liability, LiabilityEntity } from '../../../models/domain/liability';
import { utils, stubs } from './real_estate_buy_event_handler.spec.utils';
import { RealEstateBuyEventHandler } from './real_estate_buy_event_handler';
import { RealtyAsset } from '../../../models/domain/assets/realty_asset';
import { RealEstateBuyEvent } from './real_estate_buy_event';

describe('Realty buy event event handler', () => {
  const { eventId, userId, initialCash, game } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully bought new real estate', async () => {
    const handler = new RealEstateBuyEventHandler();

    const event = utils.createBuyRealEstateEvent({
      realEstateId: 'randomId',
      currentPrice: 100_000,
      fairPrice: 90_000,
      downPayment: 15_000,
      debt: 85_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
      assetName: 'Гараж',
    });

    const action = utils.createBuyRealEstateAction(eventId);

    const newGame = await handler.handle(game, event, action, userId);

    const newRealEstateAsset: RealtyAsset = {
      id: 'randomId',
      name: 'Гараж',
      type: 'realty',
      buyPrice: 100_000,
      downPayment: 15_000,
      fairPrice: 90_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    };

    const newLiability: Liability = {
      id: 'randomId',
      name: 'Гараж',
      type: LiabilityEntity.TypeValues[3],
      monthlyPayment: 0,
      value: 85_000,
    };

    const expectedGame = produce(game, (draft) => {
      draft.possessions[userId].assets.push(newRealEstateAsset);
      draft.accounts[userId].cash = initialCash - 15_000;
      draft.possessions[userId].liabilities.push(newLiability);
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Cant buy two the same real estates', async () => {
    const handler = new RealEstateBuyEventHandler();

    const event = utils.createBuyRealEstateEvent({
      realEstateId: 'existingRealtyAssetId',
      currentPrice: 100_000,
      fairPrice: 90_000,
      downPayment: 15_000,
      debt: 85_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
      assetName: 'Гараж',
    });

    const action = utils.createBuyRealEstateAction(eventId);

    await expect(handler.handle(game, event, action, userId)).rejects.toThrow(
      new Error('Cant buy two the same real estates')
    );
  });

  test('Cant buy two the same realties if liability present', async () => {
    const handler = new RealEstateBuyEventHandler();

    const newRealEstateAssetData: RealEstateBuyEvent.Data = {
      realEstateId: 'existingRealtyLiabilityId',
      currentPrice: 120_000,
      fairPrice: 30_000,
      downPayment: 110_000,
      debt: 10_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
      assetName: 'Гараж',
    };
    const event = utils.createBuyRealEstateEvent(newRealEstateAssetData);

    const action = utils.createBuyRealEstateAction(eventId);

    await expect(handler.handle(game, event, action, userId)).rejects.toThrow(
        new Error('Cant buy real estates with two the same liabilities')
      );
  });

  test('Can not buy new real estate if not enough money', async () => {
    const handler = new RealEstateBuyEventHandler();

    const newRealEstateAssetData: RealEstateBuyEvent.Data = {
      realEstateId: 'randomId',
      currentPrice: 120_000,
      fairPrice: 30_000,
      downPayment: 20_000,
      debt: 10_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
      assetName: 'Гараж',
    };

    const event = utils.createBuyRealEstateEvent(newRealEstateAssetData);

    const action = utils.createBuyRealEstateAction(eventId);

    await expect(handler.handle(game, event, action, userId)).rejects.toThrow(
        new Error('Not enough money')
      );
  });
});
