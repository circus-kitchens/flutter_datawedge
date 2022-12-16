class FlutterDatawedgeException implements Exception {
  final String message;

  FlutterDatawedgeException(this.message);

  @override
  String toString() {
    return message;
  }
}
