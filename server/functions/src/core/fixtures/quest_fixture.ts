import { GameLevel } from '../../game_levels/models/game_level';
import { GameTemplateFixture } from './game_template_fixture';

export namespace QuestFixture {
  export const createQuest = (quest: Partial<GameLevel> | undefined = undefined): GameLevel => {
    const createdQuest: GameLevel = {
      id: quest?.id || 'quest1',
      name: quest?.name || 'Quest 1',
      description: quest?.description || 'Description 1',
      icon: 'https://image.com/1',
      template: quest?.template || GameTemplateFixture.createGameTemplate(),
      levelEventConfig: quest?.levelEventConfig || {
        events: [],
      },
      monthLimit: 7,
    };

    return createdQuest;
  };
}
