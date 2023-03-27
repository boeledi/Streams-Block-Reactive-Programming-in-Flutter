import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_streams/api/tmdb_api.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/blocs/favorite_movie_bloc.dart';
import 'package:movies_streams/models/movie_card.dart';

class MovieCardWidget extends StatefulWidget {
  MovieCardWidget({
    super.key,
    required this.movieCard,
    required this.favoritesStream,
    required this.onPressed,
    this.noHero = false,
  });

  final MovieCard movieCard;
  final VoidCallback onPressed;
  final Stream<List<MovieCard>> favoritesStream;
  final bool noHero;

  @override
  MovieCardWidgetState createState() => MovieCardWidgetState();
}

class MovieCardWidgetState extends State<MovieCardWidget> {
  late FavoriteMovieBloc _bloc;

  ///
  /// In order to determine whether this particular Movie is
  /// part of the list of favorites, we need to inject the stream
  /// that gives us the list of all favorites to THIS instance
  /// of the BLoC
  ///
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  ///
  /// As Widgets can be changed by the framework at any time,
  /// we need to make sure that if this happens, we keep on
  /// listening to the stream that notifies us about favorites
  ///
  @override
  void didUpdateWidget(MovieCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  void _createBloc() {
    _bloc = FavoriteMovieBloc(widget.movieCard);

    // Simple pipe from the stream that lists all the favorites into
    // the BLoC that processes THIS particular movie
    _subscription = widget.favoritesStream.listen(_bloc.inFavorites.add);
  }

  void _disposeBloc() {
    _subscription?.cancel();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context)!;
    List<Widget> children = <Widget>[
      ClipRect(
        clipper: _SquareClipper(),
        child: widget.noHero
            ? Image.network(api.imageBaseUrl + widget.movieCard.posterPath,
                fit: BoxFit.cover)
            : Hero(
                child: Image.network(
                    api.imageBaseUrl + widget.movieCard.posterPath,
                    fit: BoxFit.cover),
                tag: 'movie_${widget.movieCard.id}',
              ),
      ),
      Container(
        decoration: _buildGradientBackground(),
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: _buildTextualInfo(widget.movieCard),
      ),
    ];

    //
    // If the movie is part of the favorites, put an icon to indicate it
    // A better way of doing this, would be to create a dedicated widget for this.
    // This would minimize the rebuild in case the icon would be toggled.
    // In this case, only the button would be rebuilt, not the whole movie card widget.
    //
    children.add(
      StreamBuilder<bool>(
          stream: _bloc.outIsFavorite,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onTap: () {
                        bloc.inRemoveFavorite.add(widget.movieCard);
                      },
                    )),
              );
            }
            return Container();
          }),
    );

    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: children,
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: <double>[0.0, 0.7, 0.7],
        colors: <Color>[
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTextualInfo(MovieCard movieCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          movieCard.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          movieCard.voteAverage.toString(),
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _SquareClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.width);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
