
class MovieCard extends Object {
  final int id;
  final voteAverage;
  final String title;
  final String posterPath;
  final String overview;

  MovieCard(this.id, this.voteAverage, this.title, this.posterPath, this.overview);

  MovieCard.fromJSON(Map<String, dynamic> json)
    : id = json['id'],
      voteAverage = json['vote_average'],
      title = json['title'],
      posterPath = json['poster_path'],
      overview = json['overview'];

  @override
  bool operator==(dynamic other) => identical(this, other) || this.id == other.id;

  @override
  int get hashCode => id;
}
