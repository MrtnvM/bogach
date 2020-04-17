class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();

  @override
  String toString() {
    return 'Email or password is incorrect';
  }
}
