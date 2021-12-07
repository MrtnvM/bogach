/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { Firestore } from './core/firebase/firestore';
import { FirestoreSelector } from './providers/firestore_selector';
import { SlackProvider } from './providers/slack/slack_provider';
import { BookRecommendationsProvider } from './providers/recommendations/book_recommendations_provider';
import { BookRecommendationsService } from './services/recommendations/book_recommendations_service';
import { FirestoreBookRecommendationsDAO } from './dao/firestore/firestore_book_recommendations_dao';
import { FIREBASE_STAGING_CONFIG, LITRES_PARTNER_ID, RECOMMENDATION_BOOKS_IDS } from './config';
import { LitresDataProvider } from './providers/recommendations/litres_data_provider';

admin.initializeApp(FIREBASE_STAGING_CONFIG);

describe('Sandbox', () => {
  test('Parse Litres books', async () => {
    jest.setTimeout(150_000);

    const firestore = admin.firestore();
    const selector = new FirestoreSelector(firestore);
    const firestoreInstance = new Firestore();

    const slackProvider = new SlackProvider();
    const litresDataProvider = new LitresDataProvider(LITRES_PARTNER_ID);

    const bookDao = new FirestoreBookRecommendationsDAO(selector, firestoreInstance);
    const bookProvider = new BookRecommendationsProvider(bookDao);
    const bookService = new BookRecommendationsService(
      litresDataProvider,
      slackProvider,
      bookProvider
    );

    await bookService.updateBooksData(RECOMMENDATION_BOOKS_IDS);
  });
});
