class EmailHasBeenTakenException implements Exception {
  const EmailHasBeenTakenException();

  @override
  String toString() {
    return 'Email has been taken';
  }
}
