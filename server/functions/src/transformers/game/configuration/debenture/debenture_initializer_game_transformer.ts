/// <reference types="@types/node"/>

import * as random from 'random';
import { produce } from 'immer';

import { GameTransformer } from '../../game_transformer';
import { Game } from '../../../../models/domain/game/game';
import { DebentureGeneratorConfig } from '../../../../events/debenture/debenture_generator_config';
import { valueRange, randomValueFromRange } from '../../../../core/data/value_range';
import { DebentureEvent } from '../../../../events/debenture/debenture_event';

export class DebentureInitializerGameTransformer extends GameTransformer {
  apply(game: Game): Game {
    const isGameCompleted = game.state.gameStatus === 'game_over';
    const isDebenturesConfigured = game.config.debentures.length !== 0;

    if (isGameCompleted || isDebenturesConfigured) {
      return game;
    }

    const debentures = [
      ...DebentureGeneratorConfig.govermentDebenture.nameOptions,
      ...DebentureGeneratorConfig.regionalDebenture.nameOptions,
      ...DebentureGeneratorConfig.corporateDebenture.nameOptions,
    ];

    const debentureCountInGame = random.int(3, 5);
    const selectedIndexes = {};
    let selectedIndexCount = 0;

    while (selectedIndexCount < debentureCountInGame) {
      const debentureIndex = random.int(0, debentures.length - 1);

      if (!selectedIndexes[debentureIndex]) {
        selectedIndexes[debentureIndex] = debentureIndex;
        selectedIndexCount++;
      }
    }

    const selectedDebentures = Object.values(selectedIndexes)
      .map((s) => debentures[s as number])
      .map((debentureName) => {
        const config = DebentureGeneratorConfig.getConfig(debentureName);

        const { price, profitability, nominal } = config;
        const nominalInCurrentGame = randomValueFromRange(nominal);
        const profitabilityInCurrentGame = randomValueFromRange(profitability);

        const debentureInfo: DebentureEvent.Info = {
          name: debentureName,
          price,
          nominal: valueRange(nominalInCurrentGame),
          profitability: valueRange(profitabilityInCurrentGame),
          availableCount: valueRange([90, 200, 10]),
        };

        return debentureInfo;
      });

    return produce(game, (draft) => {
      draft.config.debentures = selectedDebentures;
    });
  }
}
