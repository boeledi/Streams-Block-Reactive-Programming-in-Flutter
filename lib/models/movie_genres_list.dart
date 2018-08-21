import 'package:movies_streams/models/movie_genre.dart';

class MovieGenresList {
  List<MovieGenre> genres = <MovieGenre>[];

  MovieGenresList.fromJSON(Map<String, dynamic> json)
    : genres = (json["genres"] as List<dynamic>)
                .map((item) => MovieGenre.fromJSON(item)).toList();

  //
  // Return the genre by its id
  //
  MovieGenre findById(int genre) => genres.firstWhere((g) => g.genre == genre);
}