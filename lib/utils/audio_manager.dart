import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer(); // 🎵 отдельный плеер для фоновой музыки

  bool _musicStarted = false;

  AudioManager._internal();

  /// 🔊 Проигрывание коротких звуков (например, клик)
  Future<void> play(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print('Audio play error: $e');
    }
  }

  /// 🎶 Воспроизведение фоновой музыки (в цикле)
  Future<void> playBackgroundMusic(String assetPath) async {
    if (_musicStarted) return; // чтобы не запускать повторно

    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.5);

      if (kIsWeb) {
        // 🕹 На Web ждём действия пользователя
        print("⏸ Web: музыка запустится после первого клика.");
      } else {
        // 📱 На Android / iOS запускаем сразу
        await _musicPlayer.play(AssetSource(assetPath));
        _musicStarted = true;
        print("🎵 Фоновая музыка запущена автоматически (мобильная версия).");
      }
    } catch (e) {
      print('Music play error: $e');
    }
  }

  /// 🚀 Запуск музыки вручную (для Web после первого взаимодействия)
  Future<void> startMusicManually(String assetPath) async {
    if (_musicStarted) return;
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.5);
      await _musicPlayer.play(AssetSource(assetPath));
      _musicStarted = true;
      print("🎶 Фоновая музыка запущена вручную (Web).");
    } catch (e) {
      print('Manual music start error: $e');
    }
  }

  /// ⏹ Остановка фоновой музыки
  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
      _musicStarted = false;
    } catch (e) {
      print('Music stop error: $e');
    }
  }
}
