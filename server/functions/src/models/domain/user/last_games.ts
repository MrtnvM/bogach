import { GameTemplateEntity } from '../../../game_templates/models/game_template';
import { GameEntity } from '../game/game';

/// Needed for implementation of continue game feature
export interface LastGames {
  readonly singleplayerGames: LastGameInfo[];
  readonly questGames: LastGameInfo[];
  readonly multiplayerGames: LastGameInfo[];
}

export interface LastGameInfo {
  readonly gameId: GameEntity.Id;
  readonly templateId: GameTemplateEntity.Id;
  readonly createdAt?: string;
}

export namespace LastGamesEntity {
  export const initial = (): LastGames => {
    return {
      singleplayerGames: [],
      questGames: [],
      multiplayerGames: [],
    };
  };
}
