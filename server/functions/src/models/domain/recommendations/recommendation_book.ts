export type RecommendationBook = {
  bookId: string;

  title: string;
  author: string;
  pagesCount: number;
  description?: string;
  originalDescription: string;

  litres: {
    rating: number;
    reviewCount: number;
    price: number;
    bookLink: string;
    bookFragmentLink: string;
  };
};
