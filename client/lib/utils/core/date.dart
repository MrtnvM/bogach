import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? fromISO8601DateJson(dynamic date) {
  if (date == null) {
    return null;
  }

  if (date is String) {
    return DateTime.parse(date);
  }

  if (date is num) {
    return DateTime.fromMillisecondsSinceEpoch(date as int);
  }

  throw Exception('Unknown date format');
}

int? toISO8601DateJson(DateTime? date) {
  return date?.millisecondsSinceEpoch;
}

DateTime fromISO8601DateJsonStrict(dynamic date) {
  if (date is String) {
    return DateTime.parse(date);
  }

  if (date is num) {
    return DateTime.fromMillisecondsSinceEpoch(date as int);
  }

  if (date is Timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000);
  }

  throw Exception('Unknown date format');
}

int toISO8601DateJsonStrict(DateTime date) {
  return date.millisecondsSinceEpoch;
}
