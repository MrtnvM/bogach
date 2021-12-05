import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/recommendations/recommendation_book.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/recommendation_book_page.dart';
import 'package:cash_flow/presentation/recommendations/widgets/books/book_advantage.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BookItem extends HookWidget {
  const BookItem(this.book);

  final RecommendationBook book;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => appRouter.goTo(RecommendationBookPage(book.bookId)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: mediaQuery.size.width - size(16) * 2,
        ),
        padding: EdgeInsets.only(
          top: size(12),
          bottom: size(12),
          left: size(12),
          right: size(16),
        ),
        margin: EdgeInsets.all(size(16)),
        decoration: BoxDecoration(
          color: ColorRes.bookItemBackground,
          borderRadius: BorderRadius.all(Radius.circular(size(4))),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.grey.withAlpha(150),
            )
          ],
        ),
        child: MediaQuery(
          data: mediaQuery,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _BookCover(imageUrl: book.coverUrl),
              SizedBox(width: size(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BookTitle(title: book.title),
                    SizedBox(height: size(4)),
                    _BookAuthor(author: book.author),
                    SizedBox(height: size(2)),
                    const Divider(),
                    SizedBox(height: size(2)),
                    for (var i = 0; i < book.advantages.length; i++) ...[
                      BookAdvantageWidget(advantage: book.advantages[i]),
                      if (i < book.advantages.length - 1)
                        SizedBox(height: size(6)),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BookAuthor extends StatelessWidget {
  const _BookAuthor({Key? key, required this.author}) : super(key: key);

  final String author;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.bodyBlack.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _BookTitle extends StatelessWidget {
  const _BookTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Styles.bodyBlackBold.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _BookCover extends HookWidget {
  const _BookCover({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: size(168),
      ),
    );
  }
}
