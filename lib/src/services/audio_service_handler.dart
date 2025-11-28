



import 'package:audio_service/audio_service.dart';
import 'package:stream_x/src/services/audio_player_handler.dart';

class AudioServiceHandler {
  static late AudioPlayerHandler _audioHandler;

  static Future<void> initialize() async {
    _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.stream_x',
        androidNotificationChannelName: 'Audio Playback',
        androidNotificationOngoing: true,
      ),
    );
  }

  static AudioPlayerHandler get handler => _audioHandler;

}