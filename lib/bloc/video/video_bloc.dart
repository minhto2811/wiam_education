import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../data/models/video.dart';
import '../../usecase/video/get_list_video_use_case.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final GetListVideoUseCase _getListVideoUseCase;

  VideoBloc(this._getListVideoUseCase) : super(VideoInitialState()) {
    on<GetListVideoEvent>(_onGetListVideoEvent);
  }

  Future<void> _onGetListVideoEvent(
      GetListVideoEvent event, Emitter<VideoState> emit) async {
    emit(VideoLoadingState());
    final locale = LocalizedApp.of(event.context).delegate.currentLocale;
    var language = localeToString(locale);
    try {
      final videos = await _getListVideoUseCase.call(language);
      emit(VideoCompletedState(videos, null));
    } catch (e) {
      print(e);
      emit(VideoCompletedState(const [], e.toString()));
    }
  }
}
