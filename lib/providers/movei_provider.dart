import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_tv/models/movie_model.dart';

import 'package:k_tv/services/movie_service.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final movieProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final movieService = ref.watch(movieServiceProvider);
  return movieService.fetchMovies(page: 1);
});
