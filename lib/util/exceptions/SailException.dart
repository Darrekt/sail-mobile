class SailException implements Exception {
  final String message;
  SailException(this.message);

  @override
  String toString() => this.message;
}
