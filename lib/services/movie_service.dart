import 'dart:convert';

import 'package:k_tv/const/keys.dart';
import 'package:http/http.dart' as http;
import 'package:k_tv/models/movie_details_model.dart';

import 'package:k_tv/models/movie_model.dart';

class MovieService {
  static String apiKey = omdbKey;
  static const String baseUrl = "https://www.omdbapi.com/";

  Future<List<Movie>> fetchMovies({int page = 1}) async {
    final url = Uri.parse(
        "$baseUrl?apiKey=$apiKey&s=movie&type=movie&y=2025&page=$page");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["Response"] == "True") {
        return (data["Search"] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
      } else {
        throw Exception("No Movies Found: ${data['Error']}");
      }
    } else {
      throw Exception("Error Fetching Movies: ${response.statusCode}");
    }
  }

  Future<MovieDetailsModel> fetchMovieDetails({String? movieId}) async {
    if (movieId == null) {
      throw Exception("Movie Id Not Provided");
    }
    final url = Uri.parse("$baseUrl?i=$movieId&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = movieDetailsFromJson(response.body);
      if (data.response == "True") {
        return data;
      } else {
        throw Exception("No Movies Details Found");
      }
    } else {
      throw Exception("Error Fetching Movie Details: ${response.statusCode}");
    }
  }
}
