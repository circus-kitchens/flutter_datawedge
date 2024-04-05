import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Severity of the log message
enum LogSeverity {
  debug,
  info,
  warning,
  error,
}

/// A log message
class LogMessage {
  /// Create a new log message
  const LogMessage({
    required this.message,
    required this.timestamp,
    required this.severity,
    this.stackTrace,
  });
  final String message;
  final DateTime timestamp;
  final LogSeverity severity;
  final StackTrace? stackTrace;
}

class Logger extends ChangeNotifier {
  /// Create a new logger
  Logger({required this.prefix});
  final List<LogMessage> _logs = [];

  final String prefix;

  LogSeverity logLevel = LogSeverity.debug;

  /// Get the logs for a given key
  List<LogMessage> getLogs(String key, {LogSeverity? severity}) {
    if (severity != null) {
      return _logs
          .where((log) => log.severity == severity)
          .toList(growable: false);
    }
    return _logs;
  }

  /// Add a log message
  void addLog(
    String log,
    LogSeverity severity, {
    StackTrace? stackTrace,
  }) {
    final message = LogMessage(
      message: log,
      timestamp: DateTime.now(),
      severity: severity,
      stackTrace: stackTrace,
    );
    _logs.add(
      message,
    );

    final logLevelIndex = LogSeverity.values.indexOf(logLevel);
    final severityIndex = LogSeverity.values.indexOf(severity);

    if (severityIndex >= logLevelIndex) {
      developer.log(
        log,
        time: message.timestamp,
        error: stackTrace,
        name: '$prefix:${severity.toString().toUpperCase()}',
      );
    }

    notifyListeners();
  }

  /// Log a debug message
  void debug(String log) {
    addLog(log, LogSeverity.debug);
  }

  /// Log an info message
  void info(String log) {
    addLog(log, LogSeverity.info);
  }

  /// Log an error
  void error(String log, StackTrace stackTrace) {
    addLog(log, LogSeverity.error, stackTrace: stackTrace);
  }

  /// Log a warning
  void warning(String key, String log) {
    addLog(log, LogSeverity.warning);
  }

  /// Log a debug message
  void clearLogs() {
    _logs.clear();
  }
}

final logger = Logger(prefix: 'flutter_datawedge');
