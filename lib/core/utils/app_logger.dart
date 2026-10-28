import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/error_logger.dart';

final appLogger = Logger(
  printer: PrettyPrinter(methodCount: 1, errorMethodCount: 8),
);

/// ارورهای پارس کردن JSON (تو retrofit) رو لاگ می‌کنه
class AppParseErrorLogger implements ParseErrorLogger {
  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions options, {
    Response<dynamic>? response,
  }) {
    appLogger.e(
      'Parse error: ${options.method} ${options.uri}',
      error: error,
      stackTrace: stackTrace,
    );
    // بدنه‌ی واقعی پاسخ سرور، برای مقایسه با مدل‌ها
    appLogger.d('Response data: ${response?.data}');
  }
}