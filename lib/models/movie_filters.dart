class MovieFilters {
  MovieFilters({
    required this.minReleaseDate,
    required this.maxReleaseDate,
    required this.genre,
  });

  final int minReleaseDate;
  final int maxReleaseDate;
  final int genre;
}
