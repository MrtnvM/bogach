import { GameTemplate } from '../../models/domain/game/game_template';
import { PossessionsEntity } from '../../models/domain/possessions';

export namespace GameTemplateFixture {
  export const createGameTemplate = (
    template: Partial<GameTemplate> | undefined = undefined
  ): GameTemplate => {
    const gameTemplate: GameTemplate = {
      id: template?.id || 'template1',
      name: template?.name || 'Game 1',
      possessions: template?.possessions || PossessionsEntity.createEmpty(),
      accountState: template?.accountState || {
        cashFlow: 10_000,
        cash: 20_000,
        credit: 0,
      },
      target: template?.target || { type: 'cash', value: 1_000_000 },
    };

    return gameTemplate;
  };
}
