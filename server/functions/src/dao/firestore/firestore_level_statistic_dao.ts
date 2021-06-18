import { FirestoreSelector } from '../../providers/firestore_selector';
import { Firestore } from '../../core/firebase/firestore';
import { GameTemplateEntity } from '../../game_templates/models/game_template';
import { LevelStatistic } from '../../models/domain/level_statistic/level_statistic';
import { ILevelStatisticDAO } from '../level_statistic_dao';

export class FirestoreLevelStatisticDAO implements ILevelStatisticDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async updateLevelStatistic(statistic: LevelStatistic): Promise<LevelStatistic> {
    LevelStatistic.validate(statistic);

    const selector = this.selector.levelStatistic(statistic.id);
    const updatedStatistic = await this.firestore.updateItem(selector, statistic);

    return updatedStatistic as LevelStatistic;
  }

  async getLevelStatistic(templateId: GameTemplateEntity.Id): Promise<LevelStatistic> {
    const selector = this.selector.levelStatistic(templateId);
    let statistic = await this.firestore.getItemData(selector);

    if (!statistic) {
      statistic = await this.firestore.createItem(selector, {
        id: templateId,
        statistic: {},
      });
    }

    LevelStatistic.validate(statistic);

    return statistic as LevelStatistic;
  }
}
