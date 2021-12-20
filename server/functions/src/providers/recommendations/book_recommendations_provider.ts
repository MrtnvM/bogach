import { IBookRecommendationsDAO } from '../../dao/book_recommendations_dao';
import { RecommendationBook } from '../../models/domain/recommendations/books/recommendation_book';

export class BookRecommendationsProvider {
  constructor(private bookDao: IBookRecommendationsDAO) {}

  getBook(bookId: string) {
    return this.bookDao.getBook(bookId);
  }

  getBooks() {
    return this.bookDao.getBooks();
  }

  updateBook(book: Partial<RecommendationBook>) {
    return this.bookDao.updateBook(book);
  }
}
