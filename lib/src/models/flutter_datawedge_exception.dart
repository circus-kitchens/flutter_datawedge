class FlutterDatawedgeException implements Exception {
  FlutterDatawedgeException(this.message);
  final String message;
}

class NotInitializedException extends FlutterDatawedgeException {
  NotInitializedException()
    : super(
        'FlutterDataWedge is not initialized.'
        ' Call FlutterDataWedge.initialize() first.',
      );
}
