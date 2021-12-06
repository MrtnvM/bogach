/// <reference types="@types/jest"/>

import fetch from 'node-fetch';
import cheerio from 'cheerio';
import { writeJson } from './utils/json';

describe('Sandbox', () => {
  test('Parse Litres book', async () => {
    jest.setTimeout(150_000);

    const bookLinks = [
      'https://www.litres.ru/aleksey-markov-12132/hulinomika-huliganskaya-ekonomika-finansovye-rynki-dl/',
      'https://www.litres.ru/dzhorzh-semuel-kleyson/samyy-bogatyy-chelovek-v-vavilone/',
      'https://www.litres.ru/bodo-shefer/mani-ili-azbuka-deneg/',
    ];

    const books = await Promise.all(
      bookLinks.map(async (link) => {
        const book = await parseLitresBook(link);
        writeJson(`data/books/${book.title}.json`, book);
        return book;
      })
    );

    console.log('Books: ', books);
  });
});

const parseLitresBook = async (link: string) => {
  const response = await fetch(link);

  const html = await response.text();
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

  const book = {
    title,
    author,
    rating,
    reviewCount,
    price,
    pagesCount,
    originalDescription,
  };

  return book;
};
