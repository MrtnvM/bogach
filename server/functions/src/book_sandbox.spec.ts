/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { Firestore } from './core/firebase/firestore';
import { FirestoreSelector } from './providers/firestore_selector';
import { writeJson } from './utils/json';
import { LitresService } from './services/litres/litres_service';
import { BookRecommendationsProvider } from './providers/recommendations/book_recommendations_provider';
import { BookRecommendationsService } from './services/recommendations/book_recommendations_service';
import { FirestoreBookRecommendationsDAO } from './dao/firestore/firestore_book_recommendations_dao';
import { FIREBASE_STAGING_CONFIG } from './config';

const LITRES_PARTNER_ID = 432409830;

admin.initializeApp(FIREBASE_STAGING_CONFIG);

describe('Sandbox', () => {
  test('Parse Litres book', async () => {
    jest.setTimeout(150_000);

    const firestore = admin.firestore();
    const selector = new FirestoreSelector(firestore);
    const firestoreInstance = new Firestore();

    const litresService = new LitresService(LITRES_PARTNER_ID);

    const bookDao = new FirestoreBookRecommendationsDAO(selector, firestoreInstance);
    const bookProvider = new BookRecommendationsProvider(bookDao);
    const bookService = new BookRecommendationsService(bookProvider);

    const booksIds = [
      23593618, 11279349, 9361857, 22960394, 27059084, 23789575, 42132666, 29837855, 8647268,
      36628165, 6564681, 25578317,
    ];

    const books = await Promise.all(
      booksIds.map(async (bookId) => {
        const book = await litresService.parseBook(bookId);
        await bookService.updatedBook(book);
        writeJson(`data/books/${book.title}.json`, book);
        return book;
      })
    );

    console.log('Books: ', books);
  });
});
