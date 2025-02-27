import 'dart:convert';

import 'package:k_tv/const/keys.dart';
import 'package:http/http.dart' as http;

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
}
