export type RecommendationBook = {
  bookId: string;

  title: string;
  author: string;
  coverUrl?: string;
  pagesCount: number;
  description?: string;
  originalDescription: string;
  advantages?: {
    title: string;
    icon: string;
  }[];

  litres: {
    rating: number;
    reviewCount: number;
    price: number;
    bookLink: string;
    bookFragmentLink: string;
  };
};
