import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_tv/focusable.dart';

import 'package:k_tv/providers/movei_provider.dart';
import 'package:video_player/video_player.dart';

// class MovieDetailsPage extends ConsumerWidget {
//   const MovieDetailsPage({super.key, required this.movieId});

//   final String movieId;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final movieDetails = ref.watch(movieInfoProvider(movieId));

//     return movieDetails.when(
//       data: (movie) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(movie.title),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0), // Added padding for spacing
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 400,
//                   height: 400,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.brown),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       movie.poster,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Icon(Icons.broken_image,
//                             size: 100, color: Colors.red);
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 Expanded(
//                   child: Container(
//                     constraints: BoxConstraints(minHeight: 200),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.brown),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           movie.title,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10), // Space
//                         Text(
//                           "Year: ${movie.year}",
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           "Rated: ${movie.rated}",
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           "Release Date: ${movie.released}",
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           "Director: ${movie.director}",
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           "Writer: ${movie.writer}",
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           "Actors: ${movie.actors}",
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           "Genre: ${movie.genre}",
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       error: (error, stackTrace) {
//         return Scaffold(
//           body: Center(
//             child: Text("Oops!! Something Went Wrong"),
//           ),
//         );
//       },
//       loading: () => Center(child: CircularProgressIndicator()),
//     );
//   }
// }

class MovieDetailsPage extends ConsumerStatefulWidget {
  const MovieDetailsPage({super.key, required this.movieId});

  final String movieId;

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;

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
    // _videoController =
    //     VideoPlayerController.asset("assets/videos/ElephantsDream.mp4")
    //       ..initialize().then((_) {
    //         setState(() {});
    //       });
    log('VideoInitialized: $_videoController');
    // ..setLooping(true);
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
    final movieDetails = ref.watch(movieInfoProvider(widget.movieId));

    return movieDetails.when(
      data: (movie) {
        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.brown),
                    ),
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
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
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

                  const SizedBox(height: 20),

                  // Movie Details Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FocusableWidget(
                        onSelect: () {},
                        onFocus: () {},
                        child: Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.brown),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              movie.poster,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    size: 100, color: Colors.red);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(minHeight: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.brown),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Year: ${movie.year}",
                                  style: const TextStyle(fontSize: 18)),
                              Text("Rated: ${movie.rated}",
                                  style: const TextStyle(fontSize: 18)),
                              Text("Release Date: ${movie.released}",
                                  style: const TextStyle(fontSize: 18)),
                              Text("Director: ${movie.director}",
                                  style: const TextStyle(fontSize: 18)),
                              Text("Writer: ${movie.writer}",
                                  style: const TextStyle(fontSize: 18)),
                              Text("Actors: ${movie.actors}",
                                  style: const TextStyle(fontSize: 18)),
                              Text("Genre: ${movie.genre}",
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text("Oops!! Something Went Wrong"),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
