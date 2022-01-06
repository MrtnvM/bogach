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

  test.skip('Get SkillFactory data updates', async () => {
    const updates = await skillFactoryDataProvider.checkCoursesUpdates();
    console.log('COURSES UPDATES: ', updates);
  });

  test.skip('Update skipped courses', async () => {
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

  test.skip('Update course data', async () => {
    const marketAnalystCourse: Partial<Course> = {
      id: '17160316',
      profession: 'Профессия Маркетолог-аналитик',
      salaryText: 'Средняя зарплата от',
      salaryValue: 150000,
      startDate: new Date(2022, 0, 10),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fmarketing.jpeg?alt=media&token=e4b2f74b-c089-4f70-bd15-01120ed3773c',
    };

    const gameDevCourse: Partial<Course> = {
      id: '20744316',
      profession: 'Профессия Разработчик игр на Unity',
      salaryText: 'Средняя зарплата от',
      salaryValue: 120000,
      startDate: new Date(2022, 0, 18),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fgame-dev.jpeg?alt=media&token=8f87e79e-4aaa-450b-862a-e7298c2eaeee',
    };

    const javaCourse: Partial<Course> = {
      id: '14028771',
      profession: 'Профессия Java-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 140000,
      startDate: new Date(2022, 0, 25),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fjava.jpeg?alt=media&token=48956de4-57f2-48f9-ac2c-e06483155f70',
    };

    const webCourse: Partial<Course> = {
      id: '21619653',
      profession: 'Профессия Web-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 110000,
      startDate: new Date(2022, 0, 19),
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
      startDate: new Date(2022, 0, 19),
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
      startDate: new Date(2022, 0, 25),
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
      startDate: new Date(2022, 0, 12),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fdata-science.jpg?alt=media&token=46d5e029-31b7-4860-8b70-65a61f1bed67',
    };

    const iosCourse: Partial<Course> = {
      id: '19162066',
      profession: 'Профессия iOS-разработчик',
      salaryText: 'Медианная зарплата',
      salaryValue: 147000,
      startDate: new Date(2022, 0, 24),
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
      startDate: new Date(2022, 0, 13),
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
      startDate: new Date(2022, 0, 21),
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
      startDate: new Date(2022, 0, 18),
      discount: 40,
      source: 'SkillFactory',
      imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/bogach-production.appspot.com/o/recommendations%2Fcourses%2Fcourse_images%2Fqa-engineer.jpg?alt=media&token=65c5a349-d585-4922-bad8-2a347f3fe30c',
    };

    const courses = [
      marketAnalystCourse,
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
