import { GameTemplatesProvider } from './game_templates_provider';
import { GameTemplateEntity } from '../game_templates/models/game_template';

describe('Game Templates Service', () => {
  test('Successfully load game templates', () => {
    const gameTemplatesService = new GameTemplatesProvider();
    const gameTemplates = gameTemplatesService.getGameTemplates();

    expect(gameTemplates.length).toBeGreaterThan(0);
  });

  test('Check game templates configs', () => {
    const gameTemplatesService = new GameTemplatesProvider();
    const gameTemplates = gameTemplatesService.getGameTemplates();
    gameTemplates.forEach(GameTemplateEntity.validate);
  });
});
