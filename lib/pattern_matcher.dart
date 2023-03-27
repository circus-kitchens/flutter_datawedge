import 'dart:async';
import 'package:collection/collection.dart';

class PatternMatcher<T> implements StreamTransformer<T, List<T>> {
  final List<T> pattern;

  PatternMatcher(this.pattern);

  @override
  Stream<List<T>> bind(Stream<T> stream) {
    var buffer = <T>[];

    return stream.transform(StreamTransformer.fromHandlers(
      handleData: (event, sink) {
        buffer.add(event);

        if (ListEquality().equals(buffer, pattern)) {
          sink.add(buffer);
          buffer = [];
        } else if (buffer.length >= pattern.length) {
          buffer = buffer.sublist(1);
        }
      },
      handleDone: (sink) {
          sink.close();
      },
      handleError: (error, stackTrace, sink) {
        sink.addError(error, stackTrace);
      },
    ));
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    throw UnimplementedError();
  }
}
