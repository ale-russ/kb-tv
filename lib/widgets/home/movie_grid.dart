import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../focusable.dart';
import '../../models/movie_model.dart';
import '../../providers/movei_provider.dart';

class MovieGrid extends ConsumerWidget {
  const MovieGrid({
    super.key,
    required this.moviesAsyncValue,
  });

  final AsyncValue<List<Movie>> moviesAsyncValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.brown),
      ),
      child: moviesAsyncValue.when(
        data: (movies) {
          return GridView.builder(
              itemCount: movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 16 / 9),
              itemBuilder: (context, index) {
                final movie = movies[index];

                return FocusableWidget(
                  onSelect: () {
                    log("Title: ${movie.imdbID}");
                    ref.read(movieDetailProvider.notifier).state = movie;
                    context.go("/home/movie-details?movie-id=${movie.imdbID}");
                  },
                  onFocus: () => {},
                  child: InkWell(
                    autofocus: false,
                    onTap: () {
                      ref.read(movieDetailProvider.notifier).state = movie;
                      context
                          .go("/home/movie-details?movie-id=${movie.imdbID}");
                    },
                    child: Card(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.brown),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.brown,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      movie.poster,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(Icons.broken_image,
                                              size: 100, color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20),
                            Text(
                              movie.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        )),
                  ),
                );
              });
        },
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    ));
  }
}
