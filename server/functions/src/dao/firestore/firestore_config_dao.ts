import { Firestore } from '../../core/firebase/firestore';
import { CoursesConfig } from '../../models/domain/config/courses_config';
import { FirestoreSelector } from '../../providers/firestore_selector';
import { IConfigDAO } from '../config_dao';

export class FirestoreConfigDAO implements IConfigDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async getCoursesConfig(): Promise<CoursesConfig> {
    const selector = this.selector.coursesConfig();
    const coursesConfig = await this.firestore.getItemData(selector);

    if (!coursesConfig) {
      const emptyConfig: CoursesConfig = {
        lastSkillFactoryFeedFileHash: '',
        skippedCoursesIds: [],
      };

      const config = await this.firestore.createItem(selector, emptyConfig);
      return config as CoursesConfig;
    }

    return coursesConfig as CoursesConfig;
  }

  async updateCoursesConfig(coursesConfig: Partial<CoursesConfig>) {
    const selector = this.selector.coursesConfig();
    const updatedConfig = await this.firestore.updateItem(selector, coursesConfig);
    return updatedConfig;
  }
}
