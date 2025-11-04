import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Service for logging exceptions to a file
class ExceptionLogger {
  static const String _logFileName = 'mi_exception_log.txt';

  /// Writes an exception to the log file
  static Future<void> writeException(String error, {StackTrace? stackTrace}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/$_logFileName');
      
      final timestamp = DateTime.now().toIso8601String();
      final errorMessage = '[$timestamp] ERROR: $error\n';
      final stackMessage = stackTrace != null ? 'STACK TRACE:\n$stackTrace\n' : '';
      final separator = '${'=' * 80}\n';
      
      final logContent = '$separator$errorMessage$stackMessage$separator\n';
      
      // Append to log file
      await logFile.writeAsString(logContent, mode: FileMode.append);
    } catch (e) {
      // If logging fails, at least print to console
      print('Failed to write exception log: $e');
      print('Original error: $error');
    }
  }

  /// Reads the exception log file
  static Future<String?> readLog() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/$_logFileName');
      
      if (await logFile.exists()) {
        return await logFile.readAsString();
      }
      return null;
    } catch (e) {
      print('Failed to read exception log: $e');
      return null;
    }
  }

  /// Clears the exception log file
  static Future<void> clearLog() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/$_logFileName');
      
      if (await logFile.exists()) {
        await logFile.delete();
      }
    } catch (e) {
      print('Failed to clear exception log: $e');
    }
  }
}

