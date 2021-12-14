/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { FIREBASE_PRODUCTION_CONFIG, FIREBASE_STAGING_CONFIG, LITRES_PARTNER_ID } from '../config';
import { FirestoreSelector } from '../providers/firestore_selector';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreConfigDAO } from '../dao/firestore/firestore_config_dao';
import { FirestoreCourseRecommendationsDAO } from '../dao/firestore/firestore_courses_recommendations_dao';
import { FirestoreBookRecommendationsDAO } from '../dao/firestore/firestore_book_recommendations_dao';
import { SkillFactoryDataProvider } from '../providers/recommendations/skillfactory_data_provider';
import { LitresDataProvider } from '../providers/recommendations/litres_data_provider';
import { BookRecommendationsService } from '../services/recommendations/book_recommendations_service';
import { SlackProvider } from '../providers/slack/slack_provider';
import { BookRecommendationsProvider } from '../providers/recommendations/book_recommendations_provider';
import { CourseRecommendationsService } from '../services/recommendations/course_recommendations_service';
import { CourseRecommendationsProvider } from '../providers/recommendations/course_recommendations_provider';

describe('Sandbox', () => {
  jest.setTimeout(150_000);

  const getEnvironment = (config: any, name: string) => {
    const app = admin.initializeApp(config, name);

    const storage = admin.storage(app);
    const firestore = admin.firestore(app);
    const selector = new FirestoreSelector(firestore);
    const firestoreInstance = new Firestore();

    const configDao = new FirestoreConfigDAO(selector, firestoreInstance);
    const booksDao = new FirestoreBookRecommendationsDAO(selector, firestoreInstance);
    const coursesDao = new FirestoreCourseRecommendationsDAO(selector, firestoreInstance);

    const skillFactoryDataProvider = new SkillFactoryDataProvider(coursesDao, configDao);
    const litresDataProvider = new LitresDataProvider(LITRES_PARTNER_ID, storage);
    const slackProvider = new SlackProvider();
    const bookProvider = new BookRecommendationsProvider(booksDao);
    const courseProvider = new CourseRecommendationsProvider(coursesDao);

    const booksService = new BookRecommendationsService(
      litresDataProvider,
      slackProvider,
      bookProvider
    );

    const coursesService = new CourseRecommendationsService(courseProvider);

    return { booksService, coursesService, litresDataProvider, skillFactoryDataProvider };
  };

  test.skip('Copy staging books to production', async () => {
    const staging = getEnvironment(FIREBASE_STAGING_CONFIG, 'staging');
    const stagingBooks = await staging.booksService.getBooks();
    console.log('STAGING: ', stagingBooks);

    const production = getEnvironment(FIREBASE_PRODUCTION_CONFIG, 'production');
    const productionBooks = await production.booksService.getBooks();
    console.log('PRODUCTION: ', productionBooks);

    const updatedProductionBooks = await Promise.all(
      stagingBooks.map(async (b) => {
        const coverUrl = await production.litresDataProvider.downloadCover(parseInt(b.bookId, 10));
        b.coverUrl = coverUrl;
        const updatedBook = await production.booksService.updateBook(b);
        return updatedBook;
      })
    );

    console.log('PRODUCTION: ', updatedProductionBooks);
  });

  test.skip('Copy staging courses to production', async () => {
    const staging = getEnvironment(FIREBASE_STAGING_CONFIG, 'staging');
    const stagingCourses = await staging.coursesService.getCourses();
    console.log('STAGING: ', stagingCourses);

    const production = getEnvironment(FIREBASE_PRODUCTION_CONFIG, 'production');
    const productionCourses = await production.coursesService.getCourses();
    console.log('PRODUCTION: ', productionCourses);

    const updatedProductionCourses = await Promise.all(
      stagingCourses.map((c) => production.coursesService.updateCourse(c))
    );
    console.log('UPDATED PRODUCTION: ', updatedProductionCourses);
  });
});
