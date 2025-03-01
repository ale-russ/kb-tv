import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:k_tv/focusable.dart';
import 'package:k_tv/providers/movei_provider.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  const MovieDetailsPage({super.key, required this.movieId});

  final String movieId;

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  bool isPosterSelected = false;
  @override
  Widget build(BuildContext context) {
    log("movieId: ${widget.movieId}");
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      FocusableWidget(
                        onSelect: () {
                          context.pushNamed("video-player", extra: movie);
                          // context.push("/home/movie-details/?movie=$widget.movieId/video-player");
                        },
                        onFocus: () {
                          setState(() {
                            isPosterSelected = true;
                          });
                        },
                        onUnFocus: () {
                          setState(() {
                            isPosterSelected = false;
                          });
                        },
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
                      if (isPosterSelected)
                        Center(
                          child: Positioned(
                              // left: MediaQuery.of(context).size.width * 0.5,
                              child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          )),
                        )
                    ],
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
