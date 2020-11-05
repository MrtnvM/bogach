DateTime fromISO8601DateJson(dynamic date) {
  if (date == null) {
    return null;
  }

  if (date is String) {
    return DateTime.parse(date);
  }

  if (date is num) {
    return DateTime.fromMillisecondsSinceEpoch(date);
  }

  throw Exception('Unknown date format');
}

int toISO8601DateJson(DateTime date) {
  return date.millisecondsSinceEpoch;
}
