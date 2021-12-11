import * as admin from 'firebase-admin';
import fetch from 'node-fetch';
import cheerio from 'cheerio';
import { RecommendationBook } from '../../models/domain/recommendations/books/recommendation_book';
import { downloadFile } from '../../utils/download_file';

export class LitresDataProvider {
  constructor(private partnerId: number) {}

  async parseBook(bookId: number): Promise<RecommendationBook> {
    const { html, bookLink } = await this.getBookPageHtml(bookId);
    const $ = cheerio.load(html);

    const title = $('.biblio_book_name h1').text();
    const author = $('.biblio_book_author a span[itemprop="name"]').text();
    const rating = parseFloat(
      $('.rating-source-litres .rating-text-wrapper .rating-number').text().replace(/,/g, '.')
    );
    const reviewCount = parseInt(
      $('.rating-source-litres .rating-text-wrapper .votes-count').text().replace(/\s/g, ''),
      10
    );
    const price = parseInt($('.biblio_book_buy span.simple-price').text().trim(), 10);

    const pagesCountText = $('.biblio_book_info li.volume').text();
    const pagesCount = parseInt(pagesCountText.match(/[^\d]*(\d{1,})\s*стр/)![1], 10);

    const descriptionBlocks = $('div.biblio_book_descr_publishers p').toArray();
    const originalDescription = descriptionBlocks.map((b) => $(b).text()).join('\n\n');

    const bookFragmentLink = `https://www.litres.ru/pages/quickread/?art=${bookId}&skin=normal&lfrom=${this.partnerId}&l=${this.partnerId}&widget=1.00&iframe=1`;

    const book = {
      bookId: bookId.toString(),

      title,
      author,
      pagesCount,
      originalDescription,

      litres: {
        rating,
        reviewCount,
        price,
        bookLink,
        bookFragmentLink,
      },
    };

    return book;
  }

  async downloadCover(bookId: number) {
    const { html } = await this.getBookPageHtml(bookId);
    const $ = cheerio.load(html);

    const url = $('.biblio-book-cover-wrapper noscript')
      .text()
      .match(/src=\"([^\"]+)\"/)![1];

    const coverPath = `data/books/covers/${bookId}.jpeg`;
    await downloadFile(url, coverPath);

    const bucket = admin.storage().bucket();
    const [file] = await bucket.upload(coverPath, {
      destination: `recommendations/books/covers/${bookId}.jpeg`,
      public: true,
    });

    const coverUrl = file.publicUrl();
    return coverUrl;
  }

  private async getBookPageHtml(bookId: number) {
    const bookLink = `https://www.litres.ru/${bookId}/?lfrom=${this.partnerId}`;
    const response = await fetch(bookLink);

    const html = await response.text();
    return { html, bookLink };
  }
}
