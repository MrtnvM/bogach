import * as fs from 'fs';
import * as csv from 'csv-parser';
import * as _ from 'lodash';
import * as moment from 'moment';
import { ICourseRecommendationsDAO } from '../../dao/course_recommendations_dao';
import { IConfigDAO } from '../../dao/config_dao';
import { SkillFactoryFeedItem } from '../../models/domain/recommendations/courses/skillfactory/skillfactory_feed_item';
import { downloadFile } from '../../utils/download_file';
import { getFileHash } from '../../utils/files';
import { SkillFactoryCoursesUpdates } from '../../models/domain/recommendations/courses/skillfactory/skillfactory_courses_updates';
import { Course, validateCourse } from '../../models/domain/recommendations/courses/course';

export class SkillFactoryDataProvider {
  constructor(private courseDao: ICourseRecommendationsDAO, private configDao: IConfigDAO) {}

  private feedCache?: {
    items: SkillFactoryFeedItem[];
    fileHash: string;
    updatedAt: Date;
  };

  // TODO: Implement updating data & config courses hash

  async checkCoursesUpdates(): Promise<SkillFactoryCoursesUpdates> {
    const { feedCourses, feedFileHash } = await this.getFeed();

    const coursesConfig = await this.configDao.getCoursesConfig();
    const { lastSkillFactoryFeedFileHash } = coursesConfig;

    if (lastSkillFactoryFeedFileHash === feedFileHash) {
      return { newCourses: [], updatedCourses: [], deletedCourses: [], coursesWithoutChanges: [] };
    }

    const feedCoursesIds = feedCourses.map((c) => c.id);
    const feedCoursesMap = feedCourses.reduce(
      (acc, curr) => ({ ...acc, [curr.id]: curr }),
      {} as { [id: string]: SkillFactoryFeedItem }
    );

    const recommendationCourses = _.chain(feedCoursesIds)
      .difference(coursesConfig.skippedCoursesIds)
      .map((id) => feedCoursesMap[id])
      .value();
    const recommendationCoursesIds = recommendationCourses.map((c) => c.id);

    const currentCourses = await this.courseDao.getCourses();
    const currentCoursesIds = currentCourses.map((c) => c.id);

    const newCourses = _.chain(recommendationCoursesIds)
      .difference(currentCoursesIds)
      .map((id) => feedCoursesMap[id])
      .value();

    const deletedCourses = _.chain(currentCoursesIds)
      .difference(recommendationCoursesIds)
      .map((id) => feedCoursesMap[id])
      .value();
    const deletedCoursesIds = deletedCourses.map((c) => c.id);

    const maybeUpdatedCourses = _.chain(currentCoursesIds)
      .difference(deletedCoursesIds)
      .map((id) => feedCoursesMap[id])
      .value();

    const maybeUpdatedCoursesLandingHashes = await Promise.all(
      maybeUpdatedCourses.map(this.getCourseLandingHash)
    );

    const updatedCourses = maybeUpdatedCourses.filter((courseFeedItem, index) => {
      const newLandingHash = maybeUpdatedCoursesLandingHashes[index];

      const currentCourse = currentCourses.find((c) => c.id === courseFeedItem.id)!;
      const oldLandingHash = currentCourse.landingHash;

      return newLandingHash !== oldLandingHash;
    });

    const coursesWithoutChanges = _.chain(currentCourses)
      .map((c) => c.id)
      .difference(updatedCourses.map((c) => c.id))
      .map((id) => currentCourses.find((c) => c.id === id)!)
      .value();

    return { newCourses, updatedCourses, deletedCourses, coursesWithoutChanges };
  }

  async getFeed(): Promise<{ feedCourses: SkillFactoryFeedItem[]; feedFileHash: string }> {
    if (this.feedCache) {
      const { items, fileHash, updatedAt } = this.feedCache;

      const now = moment();
      const duration = moment.duration(now.diff(updatedAt));
      const durationInMinutes = duration.asMinutes();

      if (durationInMinutes <= 10) {
        return { feedCourses: items, feedFileHash: fileHash };
      }
    }

    const feedPath = await this.downloadFeedFile();
    const feedFileHash = await getFileHash(feedPath);
    const feedCourses = await this.parseFeedFile(feedPath);

    this.feedCache = { items: feedCourses, fileHash: feedFileHash, updatedAt: new Date() };

    return { feedCourses, feedFileHash };
  }

  async getFeedCourse(courseId: string): Promise<SkillFactoryFeedItem> {
    const { feedCourses } = await this.getFeed();
    const feedCourse = feedCourses.find((c) => c.id === courseId);
    if (!feedCourse) throw new Error(`Feed course with id (${courseId}) not found`);

    return feedCourse;
  }

  async updateSkippedCourses(skippedCoursesIds: string[]) {
    const { feedCourses } = await this.getFeed();
    const feedCoursesIds = feedCourses.map((c) => c.id);

    const coursesConfig = await this.configDao.getCoursesConfig();

    const deletedCoursesIds = coursesConfig.skippedCoursesIds.filter(
      (id) => !feedCoursesIds.includes(id)
    );

    const notExistingCoursesIds = skippedCoursesIds.filter((id) => !feedCoursesIds.includes(id));

    const updatedSkippedCoursesIds = _.chain(coursesConfig.skippedCoursesIds)
      .union(skippedCoursesIds)
      .difference(deletedCoursesIds)
      .difference(notExistingCoursesIds)
      .value();

    const updatedConfig = await this.configDao.updateCoursesConfig({
      skippedCoursesIds: updatedSkippedCoursesIds,
    });

    return { updatedConfig, notExistingCoursesIds, deletedCoursesIds };
  }

  async updateCourse(course: Partial<Course>) {
    const courseId = course.id;
    if (!courseId) throw new Error('No course id');

    const { feedCourses } = await this.getFeed();
    const feedCourse = feedCourses.find((c) => c.id === courseId);
    if (!feedCourse) throw new Error('No course in the feed with id: ' + courseId);

    const currentCourse = await this.courseDao.getCourse(courseId);

    const newCourse: Partial<Course> = {
      id: courseId,
      profession: course.profession || currentCourse?.profession || feedCourse?.name || undefined,
      salaryText: course.salaryText || currentCourse?.salaryText || undefined,
      salaryValue: course.salaryValue || currentCourse?.salaryValue || undefined,
      startDate: course.startDate || currentCourse?.startDate || undefined,
      discount: course.discount || currentCourse?.discount || undefined,
      source: course.source || currentCourse?.source || undefined,
      url: feedCourse.url,
      imageUrl: course.imageUrl || currentCourse?.imageUrl || undefined,
      landingHash: await this.getCourseLandingHash(feedCourse),
    };

    validateCourse(newCourse);

    const updatedCourse = await this.courseDao.updateCourse(newCourse as Course);
    return updatedCourse;
  }

  private async getCourseLandingHash(course: SkillFactoryFeedItem) {
    const courseLandingPath = `data/courses/landings/${course.name}.html`;
    await downloadFile(course.url, courseLandingPath);
    const landingHash = await getFileHash(courseLandingPath);
    return landingHash;
  }

  private async parseFeedFile(path: string): Promise<SkillFactoryFeedItem[]> {
    const results: SkillFactoryFeedItem[] = [];

    return new Promise((resolve, reject) => {
      fs.createReadStream(path)
        .pipe(
          csv({
            separator: ';',
            mapHeaders: ({ header }) => header.toLowerCase(),
          })
        )
        .on('data', (data: any) => results.push(data))
        .on('end', () => resolve(results))
        .on('error', reject);
    });
  }

  private async downloadFeedFile() {
    const feedUrl = 'https://feeds.advcake.com/feed/download/6bad02de3036462405b7afb4308f1ba8';
    const feedFilePath = 'data/courses/skill_factory_feed.csv';

    if (fs.existsSync(feedFilePath)) {
      await fs.promises.unlink(feedFilePath);
    }

    await downloadFile(feedUrl, feedFilePath);

    return feedFilePath;
  }
}
