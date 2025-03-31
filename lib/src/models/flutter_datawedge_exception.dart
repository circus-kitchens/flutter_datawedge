class FlutterDatawedgeException implements Exception {
  final String message;

  FlutterDatawedgeException(this.message);
}

class NotInitializedException extends FlutterDatawedgeException {
  NotInitializedException()
    : super(
        'FlutterDataWedgePlus is not initialized. Call FlutterDataWedgePlus.initialize() first.',
      );
}
