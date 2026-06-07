import 'package:cep_facil/core/network/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DioClient {
  DioClient._();

  static Dio create({required Talker talker}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Urls.base,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
          settings: const TalkerDioLoggerSettings(printRequestHeaders: false, printResponseHeaders: false, printResponseMessage: true),
        ),
      );
    }

    return dio;
  }
}
