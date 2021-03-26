
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime timestampToDate(dynamic timestamp) {
  final Timestamp timestampValue = timestamp;

  return DateTime.fromMicrosecondsSinceEpoch(
    timestampValue.microsecondsSinceEpoch,
  );
}