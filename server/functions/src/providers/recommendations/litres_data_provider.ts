import * as Jimp from 'jimp';
import * as admin from 'firebase-admin';
import fetch from 'node-fetch';
import cheerio from 'cheerio';
import { RecommendationBook } from '../../models/domain/recommendations/books/recommendation_book';
import { downloadFile } from '../../utils/download_file';

export class LitresDataProvider {
  constructor(private partnerId: number, private storage: admin.storage.Storage) {}

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

    let price = 0;

    const newPriceString = $('.biblio_book_buy span.new-price')?.text();
    if (newPriceString) {
      price = this.parsePrice(newPriceString);
    } else {
      const priceString = $('.biblio_book_buy span.simple-price').text();
      price = this.parsePrice(priceString);
    }

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

    const coverPath = `data/books/covers/original-${bookId}.jpeg`;
    await downloadFile(url, coverPath);

    const resizedCoverPath = `data/books/covers/original-${bookId}.jpeg`;
    const jimpImage = await Jimp.read(coverPath);
    const newHeight = 640;
    const scaleFactor = newHeight / jimpImage.getHeight();
    const newWidth = jimpImage.getWidth() * scaleFactor;

    await jimpImage.resize(newWidth, newHeight).writeAsync(resizedCoverPath);

    const bucket = this.storage.bucket();
    const [file] = await bucket.upload(resizedCoverPath, {
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

  private parsePrice(priceString?: string) {
    if (!priceString) return 0;

    const preparedValue = priceString.trim().replace(/\s/g, '').replace('₽', '');
    const priceValue = parseFloat(preparedValue);
    const price = Math.round(priceValue);

    if (!price) {
      throw new Error('Can not parse book price');
    }

    return price;
  }
}
