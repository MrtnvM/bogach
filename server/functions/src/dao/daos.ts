import { IGameDAO } from './game_dao';
import { IUserDAO } from './user_dao';
import { IRoomDAO } from './room_dao';
import { ILevelStatisticDAO } from './level_statistic_dao';
import { IBookRecommendationsDAO } from './book_recommendations_dao';

export type DAOs = {
  readonly game: IGameDAO;
  readonly user: IUserDAO;
  readonly room: IRoomDAO;
  readonly levelStatistic: ILevelStatisticDAO;
  readonly bookRecommendations: IBookRecommendationsDAO;
};
