import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/widgets/books/books_section.dart';
import 'package:cash_flow/presentation/recommendations/widgets/recommendations_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationsPage extends HookWidget {
  const RecommendationsPage();

  @override
  Widget build(BuildContext context) {
    // final size = useAdaptiveSize();

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        RecommendationsHeader(),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          children: const [
            BooksSection(),
          ],
        ),
      ],
    );
  }
}
