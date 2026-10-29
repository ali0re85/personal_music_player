import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/data/data_source/online/music_api.dart';
import 'package:music_player/domain/entity/music_pagination_entity.dart';
import 'package:music_player/domain/repository/music_repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:music_player/core/utils/app_logger.dart';

class MusicRepositoryOnline implements MusicRepository {
  late final MusicApi musicApi;

  MusicRepositoryOnline() {
    final dio = Dio();
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: false,
        ),
      );
    }
    musicApi = MusicApi(dio, errorLogger: AppParseErrorLogger());
  }

  @override
  Future<MusicPaginationEntity> getMusic({
    required int page,
    required int perPage,
  }) async {
    try {
      final model = await musicApi.getTracks(
        limit: perPage,
        offset: page * perPage,
      );
      return model.toEntity(page: page, perPage: perPage);
    } on DioException catch (e, st) {
      appLogger.e(
        'Network error: ${e.type} | status: ${e.response?.statusCode}',
        error: e.response?.data ?? e.message,
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      appLogger.e('Unknown error in getMusic', error: e, stackTrace: st);
      rethrow;
    }
  }
}
