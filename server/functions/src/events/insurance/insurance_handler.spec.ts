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

    const eventData = utils.insuranceChangedEvent({
      cost: 1200,
      movesLeft: 12,
      insuranceType: 'health',
      value: 5000,
    });

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
});
