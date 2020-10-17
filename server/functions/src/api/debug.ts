import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { GameTemplateFixture } from '../core/fixtures/game_template_fixture';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameProvider = new GameProvider(firestore, selector);

  const initializeTestData = https.onRequest(async (request, response) => {
    try {
      const template1 = GameTemplateFixture.createGameTemplate({
        id: 'template1',
      });

      const gameTemplates = await gameProvider.getAllGameTemplates();
      const gameTemplateIds = gameTemplates.map((t) => t.id);

      if (gameTemplateIds.indexOf(template1.id) < 0) {
        await gameProvider.createGameTemplate(template1);
      }

      const updatedGameTemplates = await gameProvider.getAllGameTemplates();
      response.status(200).send(updatedGameTemplates);
    } catch (error) {
      response.status(400).send(error);
    }
  });

  const isLocalEnvironment = config.getCurrentEnvironment() === 'local';

  return {
    initializeTestData: isLocalEnvironment ? initializeTestData : undefined,
  };
};
