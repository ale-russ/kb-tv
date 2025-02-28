import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:k_tv/providers/movei_provider.dart';

class MovieDetailsPage extends ConsumerWidget {
  const MovieDetailsPage({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetails = ref.watch(movieInfoProvider(movieId));

    return movieDetails.when(
      data: (movie) {
        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Added padding for spacing
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                        const SizedBox(height: 10), // Space
                        Text(
                          "Year: ${movie.year}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Rated: ${movie.rated}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Release Date: ${movie.released}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Director: ${movie.director}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Writer: ${movie.writer}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Actors: ${movie.actors}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Genre: ${movie.genre}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
