import 'package:dio/dio.dart';
import 'package:music_player/data/data_source/online/music_api.dart';
import 'package:music_player/data/models/audios_pagination_model.dart';
import 'package:music_player/domain/entity/music_pagination_entity.dart';
import 'package:music_player/domain/repository/music_repository.dart';

class MusicRepositoryOnline implements MusicRepository{
  final MusicApi musicApi = MusicApi(Dio());
  @override
  Future<MusicPaginationEntity> getMusic({required int page, required int perPage,}) async {
    final AudiosPaginationModel audiosPaginationModel=await musicApi.getTracks();
    return audiosPaginationModel.toEntity();
  }

}