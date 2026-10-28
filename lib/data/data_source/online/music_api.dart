import 'package:dio/dio.dart';
import 'package:music_player/data/models/audios_models/audios_pagination_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'music_api.g.dart';

@RestApi(baseUrl: 'https://api.audius.co/v1')
abstract class MusicApi {
  factory MusicApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _MusicApi;
  
  @GET('/tracks/search')
  Future<AudiosPaginationModel> getTracks({@Query('query') String? query});
}
