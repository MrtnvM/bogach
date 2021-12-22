import { FirestoreSelector } from '../../providers/firestore_selector';
import { Firestore } from '../../core/firebase/firestore';
import { ICourseRecommendationsDAO } from '../course_recommendations_dao';
import { Course, validateCourse } from '../../models/domain/recommendations/courses/course';
import { dateFromTimestamp } from '../../utils/datetime';

export class FirestoreCourseRecommendationsDAO implements ICourseRecommendationsDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async getCourse(courseId: string): Promise<Course | undefined> {
    const selector = this.selector.recommendationCourse(courseId);
    const course = await this.firestore.getItemData<Course>(selector);

    if (course) {
      course.startDate = dateFromTimestamp(course.startDate);
      validateCourse(course);
    }

    return course;
  }

  async getCourses(): Promise<Course[]> {
    const selector = this.selector.recommendationCourses();
    const courses = await this.firestore.getItems<Course>(selector);

    for (const course of courses) {
      course.startDate = dateFromTimestamp(course.startDate);
      validateCourse(course);
    }

    return courses;
  }

  async updateCourse(course: Course): Promise<Course> {
    const selector = this.selector.recommendationCourse(course.id);
    const existingCourse = await this.firestore.getItemData(selector);

    let updatedCourse: Course;

    if (existingCourse) {
      updatedCourse = await this.firestore.updateItem(selector, course);
    } else {
      updatedCourse = await this.firestore.createItem(selector, course);
    }

    validateCourse(updatedCourse);
    return updatedCourse;
  }
}
