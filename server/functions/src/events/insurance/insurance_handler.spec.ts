/// <reference types="@types/jest"/>

import { GameEntity } from '../../models/domain/game/game';
import produce from 'immer';
import { InsuranceHandler } from './insurance_handler';
import { utils, stubs } from './insurance_handler.spec.utils';
import { InsuranceEvent } from './insurance_event';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';

describe('Income event handler', () => {
  const { userId, game, initialCash } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully get insurance', async () => {
    const handler = new InsuranceHandler();

    const insuranceAsset: InsuranceAsset = {
      id: 'insuranceId1',
      type: 'insurance',
      cost: 1200,
      movesLeft: 12,
      value: 5000,
      insuranceType: 'health',
      name: 'СЖ',
    };

    const eventData = utils.insuranceChangedEvent(
      {
        cost: 1200,
        movesLeft: 12,
        insuranceType: 'health',
        value: 5000,
      },
      'insuranceId1'
    );

    const action: InsuranceEvent.PlayerAction = {
      eventId: 'insuranceId1',
    };
    const newGame = await handler.handle(game, eventData, action, userId);

    const expectedGame = produce(game, (draft) => {
      draft.accounts[userId].cash = initialCash - 1200;
      draft.possessions[userId].assets.push(insuranceAsset);
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully get two insurance', async () => {
    const handler = new InsuranceHandler();

    const insuranceAsset1: InsuranceAsset = {
      id: 'insuranceId1',
      type: 'insurance',
      cost: 1200,
      movesLeft: 12,
      value: 5000,
      insuranceType: 'health',
      name: 'СЖ',
    };
    const insuranceAsset2: InsuranceAsset = {
      id: 'insuranceId2',
      type: 'insurance',
      cost: 1400,
      movesLeft: 12,
      value: 6000,
      insuranceType: 'health',
      name: 'СЖ',
    };

    const eventData1 = utils.insuranceChangedEvent(
      {
        cost: 1200,
        movesLeft: 12,
        insuranceType: 'health',
        value: 5000,
      },
      'insuranceId1'
    );
    const eventData2 = utils.insuranceChangedEvent(
      {
        cost: 1400,
        movesLeft: 12,
        insuranceType: 'health',
        value: 6000,
      },
      'insuranceId2'
    );

    const action: InsuranceEvent.PlayerAction = {
      eventId: 'insuranceId1',
    };
    const action2: InsuranceEvent.PlayerAction = {
      eventId: 'insuranceId2',
    };

    const gameWith1Insurance = await handler.handle(game, eventData1, action, userId);
    const gameWith2Insurance = await handler.handle(
      gameWith1Insurance,
      eventData2,
      action2,
      userId
    );

    const expectedGame = produce(game, (draft) => {
      draft.accounts[userId].cash = initialCash - 1200 - 1400;
      draft.possessions[userId].assets.push(insuranceAsset1, insuranceAsset2);
    });

    expect(gameWith2Insurance).toStrictEqual(expectedGame);
  });
});
