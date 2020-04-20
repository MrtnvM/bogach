class UnknownErrorException implements Exception {
  UnknownErrorException();

  @override
  String toString() {
    return 'Network request error has occurred';
  }
}
