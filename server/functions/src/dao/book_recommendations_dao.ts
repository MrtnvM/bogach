import { RecommendationBook } from '../models/domain/recommendations/books/recommendation_book';

export interface IBookRecommendationsDAO {
  getBook(bookId: string): Promise<RecommendationBook | undefined>;
  getBooks(): Promise<RecommendationBook[]>;
  updateBook(book: Partial<RecommendationBook>): Promise<RecommendationBook>;
}
