// import 'dart:math' as console;

// import 'package:audio_service/audio_service.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:stream_x/src/services/audio_service_handler.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// class HomeScreenController extends GetxController {
//   // var youtubeUrl = '';

//   var youtubeUrl;
//   var isLoading = false.obs;
//   var isVideoLoaded = false.obs;
//   var isPlaying = false.obs;

//   VideoPlayerController? videoPlayerController;
//   ChewieController? chewieController;

//   final yt = YoutubeExplode();

//   // Video information
//   var videoTitle = ''.obs;
//   var channelName = ''.obs;
//   var thumbnailUrl = ''.obs;
//   var miniThumbnailUrl = ''.obs;
//   var videoDuration = ''.obs;

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     youtubeUrl = TextEditingController();
//   }

//   // Load video from URL
//   Future<void> loadVideo() async {
//     if (youtubeUrl.text.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter a YouTube URL',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // This requires a backend service or YouTube Data API
//       // String videoStreamUrl =  youtubeUrl.text;
//       // await _getYouTubeStreamUrl(youtubeUrl.value);

//       // Initialize video player controllervideoPlayerController URL
//       // videoPlayerController = VideoPlayerController.networkUrl(
//       //   ,
//       // );

//       String videoStreamUrl = await _getYouTubeStreamUrl(youtubeUrl.text);

//       // Initialize video player controller
//       videoPlayerController = VideoPlayerController.networkUrl(
//         Uri.parse(videoStreamUrl),
//       );

//       print('Video Stream URL: $videoStreamUrl');
//       print('videoPlayerController URL: $videoPlayerController');

//       // Wait for video to initialize
//       await videoPlayerController!.initialize();

//       // Initialize Chewie controller
//       chewieController = ChewieController(
//         videoPlayerController: videoPlayerController!,
//         autoPlay: false,
//         looping: false,
//         allowFullScreen: true,
//         allowMuting: true,
//         showControls: true,
//         materialProgressColors: ChewieProgressColors(
//           playedColor: const Color(0xFF1997F0),
//           handleColor: const Color(0xFF1997F0),
//           backgroundColor: Colors.grey.shade700,
//           bufferedColor: Colors.grey.shade500,
//         ),
//         placeholder: Container(
//           color: Colors.grey.shade900,
//           child: Center(
//             child: CircularProgressIndicator(color: const Color(0xFF1997F0)),
//           ),
//         ),
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Text(
//               errorMessage,
//               style: const TextStyle(color: Colors.white),
//             ),
//           );
//         },
//       );

//       videoPlayerController!.addListener(() {
//         if (videoPlayerController!.value.isPlaying) {
//           isPlaying.value = true;
//         } else {
//           isPlaying.value = false;
//         }
//       });

//       // Update UI state
//       isVideoLoaded.value = true;
//       isLoading.value = false;

//       youtubeUrl.clear();

//       Get.snackbar(
//         'Success',
//         'Video loaded successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar(
//         'Error',
//         'Failed to load video: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<String> _getYouTubeStreamUrl(String youtubeUrl) async {
//     try {
//       // Extract video ID
//       final videoId = _extractVideoId(youtubeUrl);
//       if (videoId == null) {
//         throw Exception('Invalid YouTube URL');
//       }

//       // Get video manifest
//       final streamManifest = await yt.videos.streamsClient.getManifest(videoId);

//       // Try to get muxed (audio+video) stream first
//       var streamInfo = streamManifest.muxed.withHighestBitrate();

//       // If no muxed stream available, try separate audio and video streams
//       if (streamInfo == null) {
//         final videoStream = streamManifest.videoOnly.withHighestBitrate();
//         final audioStream = streamManifest.audioOnly.withHighestBitrate();

//         if (videoStream != null && audioStream != null) {
//           // For separate streams, we'll use the video stream
//           // Note: This won't have audio. For full functionality, you'd need to mix streams
//           streamInfo = videoStream as MuxedStreamInfo;
//         } else {
//           throw Exception('No suitable stream found');
//         }
//       }

//       // Get video details for metadata
//       final video = await yt.videos.get(videoId);
//       videoTitle.value = video.title;
//       channelName.value = video.author;
//       thumbnailUrl.value = video.thumbnails.highResUrl;
//       videoDuration.value = _formatDuration(video.duration ?? Duration.zero);

//       // print('Video Title: ${streamInfo.url.toString()}');

//       print('Video Title: ${video.title}');
//       print('Video URL: ${streamInfo.url.toString()}');
//       print('Channel: ${video.author}');
//       // print('Duration: ${_formatDuration(video.duration)}');

//       return streamInfo.url.toString();
//     } catch (e) {
//       throw Exception('Failed to get stream URL: $e');
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   String? _extractVideoId(String url) {
//     final regExp = RegExp(
//       r'^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*',
//     );
//     final match = regExp.firstMatch(url);
//     return (match != null && match.groupCount >= 7) ? match.group(7) : null;
//   }

//   // Play video
//   // Play video
//   void playVideo() {
//     if (videoPlayerController != null && isVideoLoaded.value) {
//       videoPlayerController!.play();
//       isPlaying.value = true;
//     }
//   }

//   // Pause video
//   void pauseVideo() {
//     if (videoPlayerController != null) {
//       videoPlayerController!.pause();
//       isPlaying.value = false;
//     }
//   }

//   // Toggle play/pause
//   void togglePlayPause() {
//     if (isPlaying.value) {
//       pauseVideo();
//     } else {
//       playVideo();
//     }
//   }


//   //  Future<void> switchToVideo() async {
//   //   if (AudioServiceHandler.handler.isPlaying()) {
//   //     await AudioServiceHandler.handler.stop();
//   //     int currentPosition =await AudioServiceHandler.handler.retrieveCurrentPosition();

//   //     await videoPlayerController!.seekTo(Duration(milliseconds: currentPosition));
//   //     await videoPlayerController!.play();

  
//   //     update();
//   //   }
//   // }


//    Future<void> switchToAudio() async {
//     if (videoPlayerController!.value.isPlaying) {
//       int currentPosition = videoPlayerController!.value.position.inMilliseconds;
//       await videoPlayerController!.pause();

//       Duration videoDuration = videoPlayerController!.value.duration;

//       await AudioServiceHandler.handler.setMediaItem(MediaItem(
//         id: videoPlayerController!.dataSource,
//         album: '123',
//         title: VideoTitle ?? "Lesson",
//         artist: lessonDetailList["course"]["data"]["attributes"]["title"],
//         duration: videoDuration ?? Duration(minutes: 30),
//         artUri: Uri.parse(lessonDetailList["lesson"]["lesson"]["lessonimage"]),
//       ));
//       update();

//       await AudioServiceHandler.handler
//           .seek(Duration(milliseconds: currentPosition));
//       await AudioServiceHandler.handler.play();

//       isAudioPlaying = true;
//       isVideoPlaying = false;
//       update();
//     }
//   }

  
// }

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

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  final yt = YoutubeExplode();

  // Video information
  var videoTitle = ''.obs;
  var channelName = ''.obs;
  var thumbnailUrl = ''.obs;
  var videoDuration = ''.obs;
  var audioStreamUrl = ''.obs; // Store audio stream URL separately

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
      await _stopAudioService();

      // Get both video and audio stream URLs
      final streamUrls = await _getYouTubeStreamUrls(youtubeUrl.text);
      String videoStreamUrl = streamUrls['video']!;
      String audioStreamUrl = streamUrls['audio']!;

      this.audioStreamUrl.value = audioStreamUrl;

      // Initialize video player controller
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoStreamUrl),
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

  // Get both video and audio stream URLs
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

      return {
        'video': videoStreamUrl,
        'audio': audioStreamUrl,
      };
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

  // Play video
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

  // Toggle play/pause for video
  void togglePlayPause() {
    if (isPlaying.value) {
      pauseVideo();
    } else {
      playVideo();
    }
  }

  // Switch to audio-only playback
  Future<void> switchToAudio() async {
    try {
      if (videoPlayerController != null && isVideoLoaded.value && !isAudioPlaying.value) {
        // Get current position from video
        int currentPosition = videoPlayerController!.value.position.inMilliseconds;
        
        // Pause video
        await videoPlayerController!.pause();
        isPlaying.value = false;

        // Get video duration
        Duration totalDuration = videoPlayerController!.value.duration;

        // Setup audio service with media item
        await AudioServiceHandler.handler.setMediaItem(MediaItem(
          id: audioStreamUrl.value, // Use audio stream URL as ID
          title: videoTitle.value,
          artist: channelName.value,
          duration: totalDuration,
          artUri: thumbnailUrl.value.isNotEmpty ? Uri.parse(thumbnailUrl.value) : null,
        ));

        // Seek to current position and start audio playback
        await AudioServiceHandler.handler.seek(Duration(milliseconds: currentPosition));
        await AudioServiceHandler.handler.play();

        // Update states
        isAudioPlaying.value = true;
        
        Get.snackbar(
          'Audio Mode',
          'Switched to audio-only playback',
          snackPosition: SnackPosition.BOTTOM,
        );

         Future.delayed(Duration(seconds: 2), () {
        print('🚪 Closing app UI, audio continues in foreground...');
        // This will close the app but audio continues
        SystemNavigator.pop(); // Closes the app
      });


        update();
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
      if (isAudioPlaying.value) {
        // Get current position from audio service
        int? currentPosition = await AudioServiceHandler.handler.retrieveCurrentPosition();
        
        // Stop audio service
        await AudioServiceHandler.handler.stop();
        
        // Seek video to current position and play
        if (currentPosition != null) {
          await videoPlayerController!.seekTo(Duration(milliseconds: currentPosition));
        }
        await videoPlayerController!.play();

        // Update states
        isAudioPlaying.value = false;
        isPlaying.value = true;

        Get.snackbar(
          'Video Mode',
          'Switched back to video playback',
          snackPosition: SnackPosition.BOTTOM,
        );

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
  Future<void> _stopAudioService() async {
    try {
      if (isAudioPlaying.value) {
        await AudioServiceHandler.handler.stop();
        isAudioPlaying.value = false;
      }
    } catch (e) {
      print('Error stopping audio service: $e');
    }
  }

  // Dispose controllers
  Future<void> _disposeControllers() async {
    await _stopAudioService();
    
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
}
