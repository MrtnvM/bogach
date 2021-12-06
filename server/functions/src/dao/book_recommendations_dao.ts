import { RecommendationBook } from '../models/domain/recommendations/recommendation_book';

export interface IBookRecommendationsDAO {
  getBooks(): Promise<RecommendationBook[]>;
  updateBook(book: RecommendationBook): Promise<RecommendationBook>;
}
