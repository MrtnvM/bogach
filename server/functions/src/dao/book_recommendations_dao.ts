import { RecommendationBook } from '../models/domain/recommendations/recommendation_book';

export interface IBookRecommendationsDAO {
  getBooks(): Promise<RecommendationBook[]>;
  updateBook(book: Partial<RecommendationBook>): Promise<RecommendationBook>;
}
