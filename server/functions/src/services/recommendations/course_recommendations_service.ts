import { Course } from '../../models/domain/recommendations/courses/course';
import { CourseRecommendationsProvider } from '../../providers/recommendations/course_recommendations_provider';

export class CourseRecommendationsService {
  constructor(private courseProvider: CourseRecommendationsProvider) {}

  getCourses() {
    return this.courseProvider.getCourses();
  }

  updateCourse(course: Course) {
    return this.courseProvider.updateCourse(course);
  }
}
