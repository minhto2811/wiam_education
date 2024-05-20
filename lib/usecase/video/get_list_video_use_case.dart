import 'package:wiam/data/repositories/video_repository.dart';

import '../../data/models/video.dart';

class GetListVideoUseCase {
  final VideoRepository _videoRepository;

  GetListVideoUseCase(this._videoRepository);

  Future<List<Video>> call(String language) async {
    return await _videoRepository.getListVideo(language);
  }
}
