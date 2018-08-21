class MovieGenre {
  final String text;
  final int genre;

  MovieGenre(this.text, this.genre);

  MovieGenre.fromJSON(Map<String, dynamic> json)
    : genre = json["id"],
      text  = json["name"];
}