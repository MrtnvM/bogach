import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as config from '../config';

import { DAOs } from '../dao/daos';
import { SlackProvider } from '../providers/slack/slack_provider';
import { LitresDataProvider } from '../providers/recommendations/litres_data_provider';
import { BookRecommendationsService } from '../services/recommendations/book_recommendations_service';
import { BookRecommendationsProvider } from '../providers/recommendations/book_recommendations_provider';

export const create = (daos: DAOs, storage: admin.storage.Storage) => {
  const slackProvider = new SlackProvider();
  const litresDataProvider = new LitresDataProvider(config.LITRES_PARTNER_ID, storage);

  const bookProvider = new BookRecommendationsProvider(daos.bookRecommendations);
  const bookService = new BookRecommendationsService(
    litresDataProvider,
    slackProvider,
    bookProvider
  );

  const scheduledRecommendationBooksUpdate = functions
    .region(config.CLOUD_FUNCTIONS_REGION)
    .pubsub.schedule('every 24 hours')
    .onRun(async (context) => {
      await bookService.updateBooksData(config.RECOMMENDATION_BOOKS_IDS);
    });

  return { scheduledRecommendationBooksUpdate };
};
