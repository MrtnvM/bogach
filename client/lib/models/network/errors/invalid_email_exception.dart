class InvalidEmailException implements Exception {
  const InvalidEmailException();

  @override
  String toString() {
    return 'There is no such email';
  }
}
