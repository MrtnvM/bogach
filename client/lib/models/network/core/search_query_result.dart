import 'package:flutter/foundation.dart';

class SearchQueryResult<T> {
  const SearchQueryResult({
    this.searchString,
    this.items = const [],
  });

  final String searchString;
  final List<T> items;
}
