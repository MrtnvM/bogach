import { ICourseRecommendationsDAO } from '../../dao/course_recommendations_dao';
import { Course } from '../../models/domain/recommendations/courses/course';

export class CourseRecommendationsProvider {
  constructor(private courseDao: ICourseRecommendationsDAO) {}

  getCourses() {
    return this.courseDao.getCourses();
  }

  updateCourse(course: Course) {
    return this.courseDao.updateCourse(course);
  }
}
