export type SkillFactoryFeedItem = {
  id: string;
  name: string;
  description?: string;
  category: string;
  currency: string;
  price: number;
  old_price?: number;
  credit_price?: number;
  discount_sum?: number;
  discount_percent?: number;
  url: string;
  image: string;
};
