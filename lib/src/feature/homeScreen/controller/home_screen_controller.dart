// import 'dart:math' as console;



import 'dart:io';
import 'package:floating/floating.dart';
import 'package:flutter_app_minimizer_plus/flutter_app_minimizer_plus.dart';

import 'package:audio_service/audio_service.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:stream_x/src/services/audio_service_handler.dart';

class HomeScreenController extends GetxController {
  TextEditingController youtubeUrl = TextEditingController();
  var isLoading = false.obs;
  var isVideoLoaded = false.obs;
  var isPlaying = false.obs;
  var isAudioPlaying = false.obs; // Track audio playback state
  final floating = Floating();


  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  final yt = YoutubeExplode();

  // Video information
  var videoTitle = ''.obs;
  var channelName = ''.obs;
  var thumbnailUrl = ''.obs;
  var videoDuration = ''.obs;
  var audioStreamUrl = ''.obs; 

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    youtubeUrl.dispose();
    _disposeControllers();
    yt.close();
    super.onClose();
  }

  // Load video from URL
  Future<void> loadVideo() async {
    if (youtubeUrl.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a YouTube URL',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Dispose any existing controllers first
      await _disposeControllers();
      await stopAudioService();

      // Get both video and audio stream URLs
      final streamUrls = await _getYouTubeStreamUrls(youtubeUrl.text);
      String videoStreamUrl = streamUrls['video']!;
      String audioStreamUrl = streamUrls['audio']!;

      this.audioStreamUrl.value = audioStreamUrl;

      // Initialize video player controller
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoStreamUrl),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
      );

      print('Video Stream URL: $videoStreamUrl');
      print('Audio Stream URL: $audioStreamUrl');

      // Wait for video to initialize
      await videoPlayerController!.initialize();

      // Initialize Chewie controller
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
  showControlsOnInitialize: true,
  draggableProgressBar: true, // Allows seeking in small view
  systemOverlaysAfterFullScreen: SystemUiOverlay.values,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF1997F0),
          handleColor: const Color(0xFF1997F0),
          backgroundColor: Colors.grey.shade700,
          bufferedColor: Colors.grey.shade500,
        ),
        placeholder: Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: const Color(0xFF1997F0)),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      videoPlayerController!.addListener(_videoPlayerListener);

      // Update UI state
      isVideoLoaded.value = true;
      isLoading.value = false;
      isAudioPlaying.value = false;

      youtubeUrl.clear();

      Get.snackbar(
        'Success',
        'Video loaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load video: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

 
  Future<Map<String, String>> _getYouTubeStreamUrls(String youtubeUrl) async {
    try {
      // Extract video ID
      final videoId = _extractVideoId(youtubeUrl);
      if (videoId == null) {
        throw Exception('Invalid YouTube URL');
      }

      // Get video manifest
      final streamManifest = await yt.videos.streamsClient.getManifest(videoId);

      // Get video details for metadata
      final video = await yt.videos.get(videoId);
      videoTitle.value = video.title;
      channelName.value = video.author;
      thumbnailUrl.value = video.thumbnails.highResUrl;
      videoDuration.value = _formatDuration(video.duration ?? Duration.zero);

      // Try to get muxed (audio+video) stream first for video
      var videoStreamInfo = streamManifest.muxed.withHighestBitrate();
      String videoStreamUrl = videoStreamInfo?.url.toString() ?? '';

      // Get best audio stream for audio playback
      var audioStreamInfo = streamManifest.audioOnly.withHighestBitrate();
      String audioStreamUrl = audioStreamInfo?.url.toString() ?? '';

      // If no muxed stream available, try separate video stream
      if (videoStreamInfo == null) {
        final videoOnlyStream = streamManifest.videoOnly.withHighestBitrate();
        if (videoOnlyStream != null) {
          videoStreamUrl = videoOnlyStream.url.toString();
        } else {
          throw Exception('No suitable video stream found');
        }
      }

      if (audioStreamInfo == null) {
        throw Exception('No suitable audio stream found');
      }

      print('=== STREAM URLs ===');
      print('Video URL: $videoStreamUrl');
      print('Audio URL: $audioStreamUrl');
      print('Title: ${video.title}');
      print('==================');

      return {'video': videoStreamUrl, 'audio': audioStreamUrl};
    } catch (e) {
      print('Error in _getYouTubeStreamUrls: $e');
      throw Exception('Failed to get stream URLs: $e');
    }
  }

  void _videoPlayerListener() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isPlaying) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
      }
    }
  }

  void playVideo() {
    if (videoPlayerController != null && isVideoLoaded.value) {
      videoPlayerController!.play();
      isPlaying.value = true;
    }
  }

  // Pause video
  void pauseVideo() {
    if (videoPlayerController != null) {
      videoPlayerController!.pause();
      isPlaying.value = false;
    }
  }

  
  void togglePlayPause() {
    if (isPlaying.value) {
      pauseVideo();
    } else {
      playVideo();
    }
  }



  void showAudioModeInstructions() {
  Get.dialog(
    AlertDialog(
      title: Text('🎵 Audio Mode Active'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your audio is now playing in the background.'),
          SizedBox(height: 16),
          Text('📱 To continue listening:'),
          SizedBox(height: 8),
          Text('• Press the device BACK button to minimize'),
          Text('• Or switch to another app'),
          Text('• Audio will continue in notification panel'),
          SizedBox(height: 16),
          Text('🔊 Control playback from:'),
          SizedBox(height: 8),
          Text('• Notification panel'),
          Text('• Lock screen controls'),
          Text('• Headset buttons'),
        ],
      ),
      actions: [
        TextButton(
          child: Text('GOT IT'),
          onPressed: () => Get.back(),
        ),
      ],
    ),
  );
}

  // Switch to audio-only playback
  Future<void> switchToAudio() async {

     
    try {
      if (videoPlayerController != null &&
          isVideoLoaded.value &&
          !isAudioPlaying.value) {
        // Get current position from video
     isAudioPlaying.value = true;
    // showAudioModeInstructions();
    update();
        int currentPosition =
            videoPlayerController!.value.position.inMilliseconds;

        // Pause video
        await videoPlayerController!.pause();
        isPlaying.value = false;

        // Get video duration
        Duration totalDuration = videoPlayerController!.value.duration;

        // Setup audio service with media item
        await AudioServiceHandler.handler.setMediaItem(
          MediaItem(
            id:
                videoPlayerController!
                    .dataSource, 
            title: videoTitle.value,
            artist: channelName.value,
            duration: totalDuration,
            artUri:
                thumbnailUrl.value.isNotEmpty
                    ? Uri.parse(thumbnailUrl.value)
                    : null,
          ),
        );

        update();
        // Seek to current position and start audio playback
        await AudioServiceHandler.handler.seek(
          Duration(milliseconds: currentPosition),
        );
        await AudioServiceHandler.handler.play();
        // update();

   
     


     
      }
      else{
        print('object hello ');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to switch to audio: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Switch back to video playback
  Future<void> switchToVideo() async {
    try {
      if (AudioServiceHandler.handler.isPlaying()) {

        print('object inside switch to video');

         // Update states
        isAudioPlaying.value = false;
        isPlaying.value = true;
        // Get current position from audio service
        await AudioServiceHandler.handler.stop();
        int? currentPosition =
            await AudioServiceHandler.handler.retrieveCurrentPosition();

        // Stop audio service

        await videoPlayerController!.seekTo(
          Duration(milliseconds: currentPosition),
        );
        await videoPlayerController!.play();
        update();

       


      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to switch to video: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Stop audio service
  Future<void> stopAudioService() async {
      isAudioPlaying.value = false;
  try {
    bool playing =  await AudioServiceHandler.handler.isPlaying();
    if ( playing) {

      await AudioServiceHandler.handler.stop();
    }
  } catch (e) {
    print("Error stopping audio service: $e");
  }
}

  // Dispose controllers
  Future<void> _disposeControllers() async {
    await stopAudioService();

    if (chewieController != null) {
      chewieController!.dispose();
      chewieController = null;
    }
    if (videoPlayerController != null) {
      videoPlayerController!.removeListener(_videoPlayerListener);
      await videoPlayerController!.dispose();
      videoPlayerController = null;
    }

    isVideoLoaded.value = false;
    isPlaying.value = false;
  }

  // Close video player
  void closeVideo() {
    _disposeControllers();
    videoTitle.value = '';
    channelName.value = '';
    thumbnailUrl.value = '';
    videoDuration.value = '';
    audioStreamUrl.value = '';
    isAudioPlaying.value = false;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String? _extractVideoId(String url) {
    final regExp = RegExp(
      r'^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*',
    );
    final match = regExp.firstMatch(url);
    return (match != null && match.groupCount >= 7) ? match.group(7) : null;
  }


  Future<void> enterPiPMode() async {
    if (!Platform.isAndroid) return;

    final bool isPipAvailable = await floating.isPipAvailable;
    if (!isPipAvailable) {
      Get.snackbar('PiP Not Supported', 'Your device does not support PiP');
      return;
    }

    // Video MUST be playing
    if (videoPlayerController == null ||
        !videoPlayerController!.value.isInitialized) {
      Get.snackbar('PiP Error', 'Video is not ready');
      return;
    }



        if (isPipAvailable) {

          // chewieController.
         
        
        

             await floating.enable(ImmediatePiP());
     
        }
   
  }
}
