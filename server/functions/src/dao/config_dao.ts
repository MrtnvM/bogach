import { CoursesConfig } from '../models/domain/config/courses_config';

export interface IConfigDAO {
  getCoursesConfig(): Promise<CoursesConfig>;
  updateCoursesConfig(coursesConfig: Partial<CoursesConfig>);
}
