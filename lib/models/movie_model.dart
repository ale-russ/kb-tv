class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  Movie(
      {required this.title,
      required this.year,
      required this.imdbID,
      required this.poster,
      required this.type});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        title: json['Title'] ?? "",
        year: json['Year'] ?? "",
        imdbID: json['imdbID'] ?? "",
        poster: json['Poster'] ?? 'https://via.placeholder.com/150',
        type: json['Type'] ?? "");
  }
}
