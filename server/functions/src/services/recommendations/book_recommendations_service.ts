import { RecommendationBook } from '../../models/domain/recommendations/recommendation_book';
import { BookRecommendationsProvider } from '../../providers/recommendations/book_recommendations_provider';
import { LitresDataProvider } from '../../providers/recommendations/litres_data_provider';
import { SlackProvider } from '../../providers/slack/slack_provider';

export class BookRecommendationsService {
  constructor(
    private litresDataProvider: LitresDataProvider,
    private slackProvider: SlackProvider,
    private bookProvider: BookRecommendationsProvider
  ) {}

  getBooks() {
    return this.bookProvider.getBooks();
  }

  updateBook(book: Partial<RecommendationBook>) {
    return this.bookProvider.updateBook(book);
  }

  async updateBooksData(booksIds: number[]) {
    const books = await this.getBooks();

    const updates: string[] = [];

    try {
      await Promise.all(
        booksIds.map(async (bookId) => {
          const existingBook = books.find((b) => b.bookId === bookId.toString());
          await this.updateBookData(bookId, existingBook, updates);
        })
      );
    } catch (err) {
      const message = '*Error on updating Litres books data:* \n\n' + JSON.stringify(err, null, 2);
      await this.slackProvider.sendMessageToBotChannel(message);
    }

    if (updates.length > 0) {
      const message = '*Litres book data updates:* \n\n' + updates.join('\n\n');
      await this.slackProvider.sendMessageToBotChannel(message);
    } else {
      const message = '*Litres books data checked. No updates needed.*';
      await this.slackProvider.sendMessageToBotChannel(message);
    }
  }

  async updateBookData(
    bookId: number,
    existingBook: RecommendationBook | undefined,
    updates: string[]
  ) {
    const book = await this.litresDataProvider.parseBook(bookId);

    if (!existingBook?.coverUrl) {
      const coverUrl = await this.litresDataProvider.downloadCover(bookId);
      book.coverUrl = coverUrl;
    }

    if (existingBook) {
      await this.validateParsedData(existingBook, book);

      const bookUpdates = this.getBookUpdates(existingBook, book);
      if (bookUpdates) {
        updates.push(bookUpdates);
      }
    }

    const bookData = !existingBook
      ? book
      : ({
          bookId: bookId.toString(),
          litres: {
            reviewCount: book.litres.reviewCount,
            rating: book.litres.rating,
            price: book.litres.price,
          },
        } as Partial<RecommendationBook>);

    await this.updateBook(bookData);
  }

  getBookUpdates(existingBook: RecommendationBook, book: RecommendationBook) {
    const oldData = existingBook.litres;
    const newData = book.litres;

    const updates: string[] = [];

    if (oldData.rating !== newData.rating) {
      updates.push(`New rating: ${newData.rating} (was ${oldData.rating})`);
    }

    if (oldData.reviewCount !== newData.reviewCount) {
      updates.push(`New review count: ${newData.reviewCount} (was ${oldData.reviewCount})`);
    }

    if (oldData.price !== newData.price) {
      updates.push(`New price: ${newData.price} (was ${oldData.price})`);
    }

    if (updates.length > 0) {
      updates.splice(0, 0, `*${book.title}*`);
    }

    return updates.join('\n');
  }

  async validateParsedData(existingBook: RecommendationBook, book: RecommendationBook) {
    const oldReviewCount = existingBook.litres.reviewCount;
    const newReviewCount = book.litres.reviewCount;

    if (oldReviewCount > newReviewCount || newReviewCount > oldReviewCount + 500) {
      const message =
        '*Invalid book review count. Parsed book: *\n' + JSON.stringify(book, null, 2);
      await this.slackProvider.sendMessageToBotChannel(message);
      throw new Error(message);
    }

    const oldPrice = existingBook.litres.price;
    const newPrice = book.litres.price;
    if (!newPrice || newPrice > oldPrice + 500) {
      const message = 'Invalid book price. Parsed book: ' + JSON.stringify(book);
      await this.slackProvider.sendMessageToBotChannel(message);
      throw new Error(message);
    }

    const newRating = book.litres.rating;
    if (newRating < 3.5 || newRating > 5) {
      const message = 'Invalid book rating. Parsed book: ' + JSON.stringify(book);
      await this.slackProvider.sendMessageToBotChannel(message);
      throw new Error(message);
    }
  }
}
