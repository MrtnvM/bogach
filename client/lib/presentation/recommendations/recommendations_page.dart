import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/recommendations/actions/get_recommendations_books_action.dart';
import 'package:cash_flow/presentation/recommendations/widgets/books/books_section.dart';
import 'package:cash_flow/presentation/recommendations/widgets/recommendations_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationsPage extends HookWidget {
  const RecommendationsPage();

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();
    useEffect(() {
      dispatch(GetRecommendationsBooksAction());
    }, []);

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
