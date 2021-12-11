import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreListProvider<T extends StoreListItem> {
  FirestoreListProvider({
    required this.firestore,
    required this.preferences,
    required this.entityKey,
    required this.collectionName,
    required this.fromJson,
    required this.toJson,
  });

  final FirebaseFirestore firestore;
  final SharedPreferences preferences;

  final String entityKey;
  final String collectionName;

  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  String get _updatedAtKey => '${entityKey}_updated_at';

  CollectionReference get firestoreCollection =>
      firestore.collection(collectionName);

  Future<List<T>> getItems() async {
    final updatedItems = await _loadUpdatedItems();
    final cachedItems = await _getCachedItems();

    final itemsMap = <String, T>{};
    // ignore: avoid_function_literals_in_foreach_calls
    cachedItems.forEach((i) => itemsMap[i.id.toString()] = i);
    // ignore: avoid_function_literals_in_foreach_calls
    updatedItems.forEach((i) => itemsMap[i.id.toString()] = i);

    final items = itemsMap.values.toList();

    await _updateCachedItems(items);
    await _updateCachedUpdatedAtDate(items);

    return items;
  }

  Future<List<T>> _loadUpdatedItems() async {
    final cachedUpdatedAtTimestamp = _getCachedUpdatedAtTimestamp();

    final snapshot = await firestoreCollection
        .where('updatedAt', isGreaterThan: cachedUpdatedAtTimestamp)
        .get();

    final items = snapshot.docs.map((d) => fromJson(d.data())).toList();
    return items;
  }

  Future<List<T>> _getCachedItems() async {
    final itemsJson = preferences.getString(entityKey);
    if (itemsJson == null) {
      return [];
    }

    final itemsData = json.decode(itemsJson) as List<dynamic>;
    final items = itemsData.map((json) {
      final jsonData = json as Map<String, dynamic>;
      return fromJson(jsonData);
    }).toList();

    return items;
  }

  Future<void> _updateCachedItems(List<T> items) async {
    final booksData = items.map(toJson).toList();
    final booksJson = json.encode(booksData);
    await preferences.setString(entityKey, booksJson);
  }

  int _getCachedUpdatedAtTimestamp() {
    final updatedAt = preferences.getInt(_updatedAtKey);
    return updatedAt ?? 0;
  }

  Future<void> _updateCachedUpdatedAtDate(List<T> items) async {
    var maxUpdatedAt = (items[0] as dynamic).updatedAt;

    for (dynamic item in items) {
      if (item.updatedAt > maxUpdatedAt) {
        maxUpdatedAt = item.updatedAt;
      }
    }

    await preferences.setInt(_updatedAtKey, maxUpdatedAt);
  }
}
