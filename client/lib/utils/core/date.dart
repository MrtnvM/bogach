DateTime fromISO8601DateJson(String date) {
  if (date == null) {
    return null;
  }

  return DateTime.parse(date);
}

String toISO8601DateJson(DateTime date) => date.toIso8601String();
