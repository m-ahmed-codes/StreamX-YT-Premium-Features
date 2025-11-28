import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_minimizer_plus/flutter_app_minimizer_plus.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:stream_x/src/feature/homeScreen/controller/home_screen_controller.dart';
import 'package:stream_x/src/services/audio_service_handler.dart';

class StreamXScreen extends StatelessWidget {
  StreamXScreen({super.key});

  final HomeScreenController homeScreenController = Get.put(
    HomeScreenController(),
  );

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.resumed) {
  //     await homeScreenController.switchToVideo();
  //   } else if (state == AppLifecycleState.detached) {
  //     await AudioServiceHandler.handler.stop();
  //   }
  // }

  // // void _minimizeToBackground() {
  //   // This minimizes the app to background
  //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  // }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFF1997F0);
    final Color backgroundColor =
        isDarkMode ? const Color(0xFF101B22) : const Color(0xFFF6F7F8);
    final Color cardBackgroundColor =
        isDarkMode ? const Color.fromRGBO(30, 41, 59, 0.5) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF0D161C);
    final Color secondaryTextColor =
        isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF4B799B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'StreamX',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildUrlInputSection(
                  primaryColor,
                  secondaryTextColor,
                  backgroundColor,
                  isDarkMode,
                ),
                const SizedBox(height: 24),
                Obx(
                  () => _buildVideoPreviewSection(
                    primaryColor,
                    cardBackgroundColor,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      // bottomSheet: Obx(() => homeScreenController.isVideoLoaded.value
      //     ? _buildStickyMiniPlayer(isDarkMode, textColor, secondaryTextColor)
      //     : const SizedBox.shrink()),
    );
  }

  Widget _buildUrlInputSection(
    Color primaryColor,
    Color secondaryTextColor,
    Color backgroundColor,
    bool isDarkMode,
  ) {
    final Color darkMutedTextColor = const Color(0xFFCBD5E1);
    final Color darkBorderColor = const Color(0xFF334155);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YouTube URL',
          style: TextStyle(
            color: isDarkMode ? darkMutedTextColor : const Color(0xFF0D161C),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: homeScreenController.youtubeUrl,
          decoration: InputDecoration(
            hintText: 'Paste YouTube URL here',
            hintStyle: TextStyle(color: secondaryTextColor),
            filled: true,
            fillColor: isDarkMode ? backgroundColor : Colors.white,
            suffixIcon: Icon(Icons.content_paste, color: secondaryTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? darkBorderColor : const Color(0xFFCFDDE8),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? darkBorderColor : const Color(0xFFCFDDE8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ElevatedButton(
            onPressed:
                homeScreenController.isLoading.value
                    ? null
                    : () => homeScreenController.loadVideo(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              minimumSize: const Size(double.infinity, 52),
              elevation: 5,
              shadowColor: primaryColor.withOpacity(0.3),
            ),
            child:
                homeScreenController.isLoading.value
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Search Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreviewSection(
    Color primaryColor,
    Color cardBackgroundColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Column(
      children: [
        if (homeScreenController.isVideoLoaded.value) ...[
          Card(
            color: cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0.5,
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child:
                        homeScreenController.chewieController != null
                            ? Chewie(
                              controller:
                                  homeScreenController.chewieController!,
                            )
                            : Container(
                              color: Colors.black,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Loading video player...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(
                          'Video Loaded',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: primaryColor.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          homeScreenController.videoTitle.value,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          homeScreenController.channelName.value,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          'Duration: ${homeScreenController.videoDuration.value}',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(

                  () => ElevatedButton.icon(
                    onPressed: () async {
                      if (homeScreenController.isAudioPlaying.value) {
                        // If audio is playing, stop it
                        // await homeScreenController.stopAudioService();
                        await homeScreenController.switchToVideo();
                        // Get.snackbar(
                        //   'Audio Stopped',
                        //   'Audio playback has been stopped',
                        //   snackPosition: SnackPosition.BOTTOM,
                        //   duration: Duration(seconds: 2),
                        // );
                        // homeScreenController.update();
                      } else {
                        // If audio is not playing, start it

                    

                        await homeScreenController.switchToAudio();
                        // FlutterAppMinimizerPlus.minimizeApp(); // Uncomment if you want to minimize
                        // Get.snackbar(
                        //   'Audio Only',
                        //   'Playing audio stream',
                        //   snackPosition: SnackPosition.BOTTOM,
                        //   duration: Duration(seconds: 2),
                        // );
                       

                          // homeScreenController.update();
                      }
                    },
                    icon: Icon(
                      homeScreenController.isAudioPlaying.value
                          ? Icons.stop
                          : Icons.headphones,
                    ),
                    label: Text(
                      homeScreenController.isAudioPlaying.value
                          ? 'Stop Audio'
                          : 'Audio Only',
                    ),
                    style: _playbackButtonStyle(
                      homeScreenController.isAudioPlaying.value
                          ? Colors
                              .red // Red color when stopping
                          : primaryColor,
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: ElevatedButton.icon(
              //     onPressed: () async{
              //       // Audio only functionality
              //       homeScreenController.switchToAudio();
              //       // FlutterAppMinimizerPlus.minimizeApp();
              //       // Get.snackbar(
              //       //   'Audio Only',
              //       //   'Playing audio stream',
              //       //   snackPosition: SnackPosition.BOTTOM,
              //       // );
              //     },
              //     icon: const Icon(Icons.headphones),
              //     label: const Text('Audio Only'),
              //     style: _playbackButtonStyle(primaryColor),
              //   ),
              // ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      'PiP Mode',
                      'Picture in Picture mode would be activated here',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.picture_in_picture_alt),
                  label: const Text('PiP Mode'),
                  style: _playbackButtonStyle(primaryColor),
                ),
              ),
            ],
          ),
        ] else ...[
          // Placeholder when no video is loaded
          Card(
            color: cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0.5,
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill_outlined,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Enter a YouTube URL and click "Search Video" to load content',
                    style: TextStyle(color: secondaryTextColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  ButtonStyle _playbackButtonStyle(Color primaryColor) {
    return ElevatedButton.styleFrom(
      foregroundColor: primaryColor,
      backgroundColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
      minimumSize: const Size(0, 56),
      elevation: 0,
    );
  }

  Widget _buildStickyMiniPlayer(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final Color miniPlayerBackgroundColor =
        isDarkMode
            ? const Color.fromRGBO(15, 23, 42, 0.8)
            : Colors.white.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Material(
            color: miniPlayerBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Obx(
                    () => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          homeScreenController.thumbnailUrl.value.isNotEmpty
                              ? Image.network(
                                homeScreenController.thumbnailUrl.value,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey,
                                    child: Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              )
                              : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey,
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Text(
                            homeScreenController.videoTitle.value,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Obx(
                          () => Text(
                            homeScreenController.channelName.value,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        homeScreenController.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                      ),
                      color: textColor,
                      onPressed: () => homeScreenController.togglePlayPause(),
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.close),
                  //   color: textColor,
                  //   onPressed: () => homeScreenController.closeVideo(),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
