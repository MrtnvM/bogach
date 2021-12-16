import { Course } from '../course';
import { SkillFactoryFeedItem } from './skillfactory_feed_item';

export type SkillFactoryCoursesUpdates = {
  newCourses: SkillFactoryFeedItem[];
  updatedCourses: SkillFactoryFeedItem[];
  deletedCourses: SkillFactoryFeedItem[];

  coursesWithoutChanges: Course[];
};
