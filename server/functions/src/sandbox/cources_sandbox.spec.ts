/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import * as _ from 'lodash';
import { FIREBASE_STAGING_CONFIG } from '../config';
import { FirestoreSelector } from '../providers/firestore_selector';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreConfigDAO } from '../dao/firestore/firestore_config_dao';
import { FirestoreCourseRecommendationsDAO } from '../dao/firestore/firestore_courses_recommendations_dao';
import { SkillFactoryDataProvider } from '../providers/recommendations/skillfactory_data_provider';
import { Course } from '../models/domain/recommendations/courses/course';

admin.initializeApp(FIREBASE_STAGING_CONFIG);

describe('Sandbox', () => {
  jest.setTimeout(150_000);

  const firestore = admin.firestore();
  const selector = new FirestoreSelector(firestore);
  const firestoreInstance = new Firestore();

  const configDao = new FirestoreConfigDAO(selector, firestoreInstance);
  const coursesDao = new FirestoreCourseRecommendationsDAO(selector, firestoreInstance);

  const skillFactoryDataProvider = new SkillFactoryDataProvider(coursesDao, configDao);

  test('Get SkillFactory data updates', async () => {
    const updates = await skillFactoryDataProvider.checkCoursesUpdates();
    console.log('COURSES UPDATES: ', updates);
  });

  test('Update skipped courses', async () => {
    const skippedCoursesIds = [
      '10823281',
      '23564079',
      '12224989',
      '9111361',
      '12212791',
      '9501716',
      '5036894',
      '8229872',
      '8677119',
      '19654604',
      '13107124',
      '13339992',
      '11933027',
      '5495482',
      '13597465',
      '11941057',
    ];

    const result = await skillFactoryDataProvider.updateSkippedCourses(skippedCoursesIds);
    console.log('RESULT: ', result);
  });

  test.only('Update course data', async () => {
    const gameDevCourse: Partial<Course> = {
      id: '20744316',
      profession: 'Профессия Разработчик игр на Unity',
      salaryText: 'Средняя зарплата от',
      salaryValue: 120000,
      startDate: new Date(2021, 12, 14),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fcourse_images%2Fgame-dev.jpg?alt=media&token=a02ba5f7-7627-4038-8c08-3b9d50b7ee5d',
    };

    const javaCourse: Partial<Course> = {
      id: '14028771',
      profession: 'Профессия Java-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 140000,
      startDate: new Date(2021, 12, 28),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fcourse_images%2Fjava.jpg?alt=media&token=94a4d571-fbe5-42f7-92e6-efd11a23b837',
    };

    const webCourse: Partial<Course> = {
      id: '21619653',
      profession: 'Профессия Web-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 110000,
      startDate: new Date(2022, 1, 19),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fcourse_images%2Fweb.jpg?alt=media&token=28b9a92d-aeeb-4b57-91d3-7822ef05b7b7',
    };

    const systemAdminCourse: Partial<Course> = {
      id: '14103488',
      profession: 'Профессия Системный администратор',
      salaryText: 'Медианная зарплата',
      salaryValue: 91000,
      startDate: new Date(2022, 1, 19),
      discount: 60,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fsystem-admin.jpg?alt=media&token=cdafd92f-917a-49a0-8e81-63110bf6bdab',
    };

    const androidCourse: Partial<Course> = {
      id: '11228019',
      profession: 'Профессия Android-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 150000,
      startDate: new Date(2021, 12, 28),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fandroid-developer.jpg?alt=media&token=e15c172d-6f78-4d30-9258-788fd44fd926',
    };

    const dataScienceCourse: Partial<Course> = {
      id: '10085909',
      profession: 'Профессия Data Scientist',
      salaryText: 'Средняя зарплата',
      salaryValue: 250000,
      startDate: new Date(2021, 12, 15),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fandroid-developer.jpg?alt=media&token=e15c172d-6f78-4d30-9258-788fd44fd926',
    };

    const iosCourse: Partial<Course> = {
      id: '19162066',
      profession: 'Профессия iOS-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 147000,
      startDate: new Date(2021, 12, 27),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fios-dev.jpg?alt=media&token=45d768ed-6bb1-40f1-8eb7-2055dd6c53fa',
    };

    const hackerCourse: Partial<Course> = {
      id: '14039106',
      profession: 'Профессия Этичный хакер',
      salaryText: 'Медианная зарплата',
      salaryValue: 120000,
      startDate: new Date(2021, 12, 16),
      discount: 50,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fhacker.jpg?alt=media&token=d36bb7a7-7f5c-4753-825d-d951994b585b',
    };

    const pythonCourse: Partial<Course> = {
      id: '19166124',
      profession: 'Профессия Python-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 120000,
      startDate: new Date(2021, 12, 24),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fpython-dev.jpg?alt=media&token=59aebac0-cdf7-4ed5-ba3f-43225013b8ab',
    };

    const qaCourse: Partial<Course> = {
      id: '20563461',
      profession: 'Профессия Инженер по ручному тестированию',
      salaryText: 'Средняя зарплата от',
      salaryValue: 60000,
      startDate: new Date(2021, 12, 14),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fqa-engineer.jpg?alt=media&token=65c5a349-d585-4922-bad8-2a347f3fe30c',
    };

    const courses = [
      gameDevCourse,
      javaCourse,
      webCourse,
      systemAdminCourse,
      androidCourse,
      dataScienceCourse,
      iosCourse,
      hackerCourse,
      pythonCourse,
      qaCourse,
    ];

    /// This will cache feed data for the rest requests
    await skillFactoryDataProvider.getFeed();

    const results = await Promise.all(courses.map((c) => skillFactoryDataProvider.updateCourse(c)));
    console.log('RESULTS: ', results);
  });
});
