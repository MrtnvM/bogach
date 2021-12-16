/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { SlackProvider } from '../providers/slack/slack_provider';
import { BookRecommendationsProvider } from '../providers/recommendations/book_recommendations_provider';
import { BookRecommendationsService } from '../services/recommendations/book_recommendations_service';
import { FirestoreBookRecommendationsDAO } from '../dao/firestore/firestore_book_recommendations_dao';
import { FIREBASE_STAGING_CONFIG, LITRES_PARTNER_ID, RECOMMENDATION_BOOKS_IDS } from '../config';
import { LitresDataProvider } from '../providers/recommendations/litres_data_provider';
import { RecommendationBook } from '../models/domain/recommendations/books/recommendation_book';

admin.initializeApp(FIREBASE_STAGING_CONFIG);

describe('Sandbox', () => {
  jest.setTimeout(150_000);

  const storage = admin.storage();
  const firestore = admin.firestore();
  const selector = new FirestoreSelector(firestore);
  const firestoreInstance = new Firestore();

  const slackProvider = new SlackProvider();
  const litresDataProvider = new LitresDataProvider(LITRES_PARTNER_ID, storage);

  const bookDao = new FirestoreBookRecommendationsDAO(selector, firestoreInstance);
  const bookProvider = new BookRecommendationsProvider(bookDao);
  const bookService = new BookRecommendationsService(
    litresDataProvider,
    slackProvider,
    bookProvider
  );

  test.skip('Parse Litres books', async () => {
    await bookService.updateBooksData(RECOMMENDATION_BOOKS_IDS);
  });

  test.skip('Update book data', async () => {
    const book: Partial<RecommendationBook> = {
      bookId: undefined,
    };

    const result = await bookService.updateBook(book);
    console.log('RESULT: ', result);
  });
});
