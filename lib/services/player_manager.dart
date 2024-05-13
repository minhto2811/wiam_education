import 'package:audioplayers/audioplayers.dart';

class PlayerManager {
  static final PlayerManager _instance = PlayerManager._();

  factory PlayerManager() {
    return _instance;
  }

  PlayerManager._();

  static final AudioPlayer _player = AudioPlayer(playerId: "player_manager");
  static double _defaultVolume = 1.0;

  void playFromAssets(String source) {
    _player.play(AssetSource(source), volume: _defaultVolume);
  }

  void playFromUrl(String source) {
    _player.play(UrlSource(source), volume: _defaultVolume);
  }

  void playWhenClick() =>
      _player.play(AssetSource('audios/click.mp3'), volume: _defaultVolume);

  void release() => _player.release();

  void stop() => _player.stop();

  void dispose() => _player.dispose();

  void setVolume(double volume) => _defaultVolume = volume;

  void playCorrectAnswer() {
    _player.play(AssetSource('audios/victory.mp3'), volume: _defaultVolume);
  }

  void playWrongAnswer() =>
      _player.play(AssetSource('audios/lose.mp3'), volume: _defaultVolume);
}
