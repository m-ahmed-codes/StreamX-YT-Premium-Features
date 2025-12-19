


import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:stream_x/src/feature/homeScreen/controller/home_screen_controller.dart';

GetBuilder<HomeScreenController> VideoPlayerWidget(
    HomeScreenController homecreenController) {
  return GetBuilder<HomeScreenController>(
    builder: (controller) {
      if (controller.videoPlayerController == null ||
          !controller.videoPlayerController!.value.isInitialized) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child:Container(
                              color: Colors.black,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Color(0xFF1997F0),
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
        );
      }

      if (controller.chewieController == null) {
        return AspectRatio(
          aspectRatio: controller.videoPlayerController!.value.aspectRatio,
          child:Container(
                              color: Colors.black,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Color(0xFF1997F0),
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
        );
      }

      return AspectRatio(
        aspectRatio: 16/9,
        child: Chewie(

          controller: controller.chewieController!,
          key: ValueKey(controller.audioStreamUrl),
        ),
      );
    },
  );
}
