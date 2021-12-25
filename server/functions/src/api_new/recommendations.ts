import * as admin from 'firebase-admin';
import * as express from 'express';
import * as config from '../config';

import { DAOs } from '../dao/daos';
import { SlackProvider } from '../providers/slack/slack_provider';
import { LitresDataProvider } from '../providers/recommendations/litres_data_provider';
import { BookRecommendationsService } from '../services/recommendations/book_recommendations_service';
import { BookRecommendationsProvider } from '../providers/recommendations/book_recommendations_provider';

const cron = require('node-cron');

export const initialize = (daos: DAOs, storage: admin.storage.Storage, app: express.Express) => {
  const slackProvider = new SlackProvider();
  const litresDataProvider = new LitresDataProvider(config.LITRES_PARTNER_ID, storage);

  const bookProvider = new BookRecommendationsProvider(daos.bookRecommendations);
  const bookService = new BookRecommendationsService(
    litresDataProvider,
    slackProvider,
    bookProvider
  );

  cron.schedule('0 0 19 * * *', async () => {
    await bookService.updateBooksData(config.RECOMMENDATION_BOOKS_IDS);
  });
};
