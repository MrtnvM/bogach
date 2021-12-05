import 'package:flutter/material.dart';

class CurrentRecommendationBookDataProvider extends InheritedWidget {
  const CurrentRecommendationBookDataProvider({
    Key? key,
    required this.bookId,
    required Widget child,
  }) : super(key: key, child: child);

  final String bookId;

  static CurrentRecommendationBookDataProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<
        CurrentRecommendationBookDataProvider>();
    assert(result != null,
        'No CurrentRecommendationBookDataProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CurrentRecommendationBookDataProvider oldWidget) {
    return oldWidget.bookId != bookId;
  }
}
