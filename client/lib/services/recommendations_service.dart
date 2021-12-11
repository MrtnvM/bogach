import 'dart:convert';

import 'package:cash_flow/core/data/firestore_list_provider.dart';
import 'package:cash_flow/models/domain/recommendations/books/recommendation_book.dart';
import 'package:cash_flow/models/domain/recommendations/courses/recommendation_course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationsService {
  RecommendationsService({
    required this.firestore,
    required this.preferences,
  });

  final FirebaseFirestore firestore;
  final SharedPreferences preferences;

  late final FirestoreListProvider<RecommendationCourse> courcesProvider =
      FirestoreListProvider(
    firestore: firestore,
    preferences: preferences,
    collectionName: 'recommendation_courses',
    entityKey: 'recommendation_courses',
    fromJson: (json) => RecommendationCourse.fromJson(json),
    toJson: (c) => c.toJson(),
  );

  static const keyRecommendationBooks = 'recommendation_books';
  static const keyRecommendationBooksUpdatedAt =
      'recommendation_books_updated_at';

  CollectionReference get recommendationsBooksCollections =>
      firestore.collection('recommendation_books');

  Future<List<RecommendationBook>> getBooks() async {
    final updatedBooks = await _loadUpdatedBooks();
    final cachedBooks = await _getCachedBooks();

    final booksMap = <String, RecommendationBook>{};
    // ignore: avoid_function_literals_in_foreach_calls
    cachedBooks.forEach((b) => booksMap[b.bookId] = b);
    // ignore: avoid_function_literals_in_foreach_calls
    updatedBooks.forEach((b) => booksMap[b.bookId] = b);

    final books = booksMap.values.toList();

    await _updateCachedBooks(books);
    await _updateCachedUpdatedAtDateForBooks(books);

    return books;
  }

  Future<List<RecommendationCourse>> getCourses() {
    return courcesProvider.getItems();
  }

  Future<List<RecommendationBook>> _loadUpdatedBooks() async {
    final cachedUpdatedAtTimestamp = _getCachedUpdatedAtTimestampForBooks();

    final snapshot = await recommendationsBooksCollections
        .where('updatedAt', isGreaterThan: cachedUpdatedAtTimestamp)
        .get();

    final books = snapshot.docs
        .map((d) => RecommendationBook.fromJson(d.data()))
        .toList();

    return books;
  }

  Future<List<RecommendationBook>> _getCachedBooks() async {
    final booksJson = preferences.getString(keyRecommendationBooks);
    if (booksJson == null) {
      return [];
    }

    final booksData = json.decode(booksJson) as List;
    final books = booksData.map((d) => RecommendationBook.fromJson(d)).toList();
    return books;
  }

  Future<void> _updateCachedBooks(List<RecommendationBook> books) async {
    final booksData = books.map((b) => b.toJson()).toList();
    final booksJson = json.encode(booksData);
    await preferences.setString(keyRecommendationBooks, booksJson);
  }

  int _getCachedUpdatedAtTimestampForBooks() {
    final updatedAt = preferences.getInt(keyRecommendationBooksUpdatedAt);
    return updatedAt ?? 0;
  }

  Future<void> _updateCachedUpdatedAtDateForBooks(
    List<RecommendationBook> books,
  ) async {
    var maxUpdatedAt = books[0].updatedAt;

    for (final book in books) {
      if (book.updatedAt > maxUpdatedAt) {
        maxUpdatedAt = book.updatedAt;
      }
    }

    await preferences.setInt(keyRecommendationBooksUpdatedAt, maxUpdatedAt);
  }
}
