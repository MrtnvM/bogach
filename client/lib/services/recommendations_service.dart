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
    cacheEntityKey: 'recommendation_courses',
    fromJson: (json) => RecommendationCourse.fromJson(json),
    toJson: (c) => c.toJson(),
  );

  late final FirestoreListProvider<RecommendationBook> booksProvider =
      FirestoreListProvider(
    firestore: firestore,
    preferences: preferences,
    collectionName: 'recommendation_books',
    cacheEntityKey: 'recommendation_books',
    fromJson: (json) => RecommendationBook.fromJson(json),
    toJson: (c) => c.toJson(),
  );

  Future<List<RecommendationBook>> getBooks() async {
    return booksProvider.getItems();
  }

  Future<List<RecommendationCourse>> getCourses() {
    return courcesProvider.getItems();
  }
}
