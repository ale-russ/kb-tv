import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_tv/models/movie_details_model.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends ConsumerStatefulWidget {
  const VideoPlayerPage({super.key, required this.movieDetails});

  final MovieDetailsModel movieDetails;

  @override
  ConsumerState<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends ConsumerState<VideoPlayerPage> {
  bool _isPlaying = false;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with a sample movie URL
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    )..initialize().then((_) {
        setState(() {}); // Refresh UI when video is ready
      });

    log('VideoInitialized: $_videoController');
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _isPlaying = false;
      } else {
        _videoController.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log('Movie: ${widget.movieDetails.title}');
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.brown),
            borderRadius: BorderRadius.circular(12)),
        child: _videoController.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.stop,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            _videoController.pause();
                            _videoController.seekTo(Duration.zero);
                            setState(() => _isPlaying = false);
                          },
                        ),
                        IconButton(
                            onPressed: () {
                              _videoController.setVolume(-0.5);
                              setState(() {});
                            },
                            icon: Icon(Icons.volume_down)),
                        IconButton(
                            onPressed: () {
                              _videoController.setVolume(0.5);
                              setState(() {});
                            },
                            icon: Icon(Icons.volume_up))
                      ],
                    ),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
