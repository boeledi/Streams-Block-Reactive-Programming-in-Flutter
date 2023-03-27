import 'package:movies_streams/models/movie_card.dart';

class MoviePageResult {
  final int pageIndex;
  final int totalResults;
  final int totalPages;
  final List<MovieCard> movies;

  MoviePageResult.fromJSON(Map<String, dynamic> json)
      : pageIndex = json['page'],
        totalResults = json['total_results'],
        totalPages = json['total_pages'],
        movies = (json['results'] as List)
            .map((json) => MovieCard.fromJSON(json))
            .toList();
}
