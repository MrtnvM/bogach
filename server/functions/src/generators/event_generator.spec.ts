/// <reference types="@types/jest"/>

import produce from 'immer';
import { GameEntity } from '../models/domain/game/game';
import { stubs } from './event_generator.spec.utils';
import { GameEventsTransformer } from '../transformers/game/game_events_transformer';

describe('Stock price changed event handler', () => {
  const { game } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully bought new stock', async () => {
    const accountsStateTransformer = new GameEventsTransformer(true);
    const newGame = accountsStateTransformer.apply(game);

    const expectedGame = produce(game, (draft) => {
    });

    expect(newGame).toStrictEqual(expectedGame);
  });
});
