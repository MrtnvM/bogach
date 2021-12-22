import { FirestoreSelector } from '../../providers/firestore_selector';
import { Firestore } from '../../core/firebase/firestore';
import { IBookRecommendationsDAO } from '../book_recommendations_dao';
import { RecommendationBook } from '../../models/domain/recommendations/books/recommendation_book';

export class FirestoreBookRecommendationsDAO implements IBookRecommendationsDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async getBook(bookId: string): Promise<RecommendationBook | undefined> {
    const selector = this.selector.recommendationBook(bookId);
    const book = await this.firestore.getItemData<RecommendationBook>(selector);
    return book;
  }

  async getBooks(): Promise<RecommendationBook[]> {
    const selector = this.selector.recommendationBooks();
    const books = await this.firestore.getItems<RecommendationBook>(selector);
    return books;
  }

  async updateBook(book: RecommendationBook): Promise<RecommendationBook> {
    const selector = this.selector.recommendationBook(book.bookId);

    try {
      const updatedBook = await this.firestore.updateItem(selector, book);
      return updatedBook;
    } catch (error: any) {
      if (error?.code === 5) {
        const createdBook = await this.firestore.createItem(selector, book);
        return createdBook;
      }

      throw error;
    }
  }
}
