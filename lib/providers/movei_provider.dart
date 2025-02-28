import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_tv/models/movie_details_model.dart';
import 'package:k_tv/models/movie_model.dart';

import 'package:k_tv/services/movie_service.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final movieProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final movieService = ref.watch(movieServiceProvider);
  return movieService.fetchMovies(page: 1);
});

final movieInfoProvider = FutureProvider.family
    .autoDispose<MovieDetailsModel, String>((ref, movieId) async {
  final movieService = ref.watch(movieServiceProvider);
  return movieService.fetchMovieDetails(movieId: movieId);
});

final movieDetailProvider = StateProvider<Movie>(
  (ref) => Movie(imdbID: "", title: "", type: "", poster: "", year: ""),
);
