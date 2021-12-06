import { RecommendationBook } from '../../models/domain/recommendations/recommendation_book';
import { BookRecommendationsProvider } from '../../providers/recommendations/book_recommendations_provider';

export class BookRecommendationsService {
  constructor(private bookProvider: BookRecommendationsProvider) {}

  getBooks() {
    return this.bookProvider.getBooks();
  }

  updatedBook(book: RecommendationBook) {
    return this.bookProvider.updateBook(book);
  }
}
