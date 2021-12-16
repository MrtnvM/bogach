import { Course } from '../models/domain/recommendations/courses/course';

export interface ICourseRecommendationsDAO {
  getCourses(): Promise<Course[]>;
  getCourse(courseId: string): Promise<Course | undefined>;
  updateCourse(course: Course): Promise<Course>;
}
