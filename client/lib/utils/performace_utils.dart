import 'package:firebase_performance/firebase_performance.dart';

HttpMethod getHttpMethodFromString(final String name) {
  final normalizedName = name?.toLowerCase() ?? '';

  for (final value in HttpMethod.values) {
    if (value.toString().split('.').last.toLowerCase() == normalizedName) {
      return value;
    }
  }

  return HttpMethod.Trace;
}
