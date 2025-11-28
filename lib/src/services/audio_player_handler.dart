


import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_x/src/feature/homeScreen/controller/home_screen_controller.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  
  final HomeScreenController homeScreenController = Get.put(
    HomeScreenController(),
  );

  
  AudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    
    mediaItem.add(MediaItem(
      id: 'https://example.com/audio.mp3',
      album: 'Islam by Abu Abdisalam',
      title: 'Lecture 1',
      artist: 'Speaker Name',
      duration: const Duration(minutes: 25),
      // artUri: Uri.parse(appLogo),
    ));
  }

  
  Future<void> setMediaItem(MediaItem item) async {
    mediaItem.add(item);
    await _player.setAudioSource(
        AudioSource.uri(Uri.parse(item.id)),
      preload: true,
    );
  }

  
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async{
    homeScreenController.stopAudioService();

  _player.stop();
  } 

  Future<int> retrieveCurrentPosition() async {
    return _player.position.inMilliseconds;
  }

  bool isPlaying() => _player.playing;

  
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,

        MediaControl.rewind,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}






