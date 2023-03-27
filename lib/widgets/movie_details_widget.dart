import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_streams/api/tmdb_api.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/blocs/favorite_movie_bloc.dart';
import 'package:movies_streams/models/movie_card.dart';

class MovieDetailsWidget extends StatefulWidget {
  MovieDetailsWidget({
    super.key,
    required this.favoritesStream,
    required this.movieCard,
    this.boxFit = BoxFit.cover,
  });

  final MovieCard movieCard;
  final BoxFit boxFit;
  final Stream<List<MovieCard>> favoritesStream;

  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
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
  void didUpdateWidget(MovieDetailsWidget oldWidget) {
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

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Hero(
                  child: Image.network(
                    api.imageBaseUrl + widget.movieCard.posterPath,
                    fit: widget.boxFit,
                  ),
                  tag: 'movie_${widget.movieCard.id}',
                ),
                StreamBuilder<bool>(
                  stream: _bloc.outIsFavorite,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: InkWell(
                        onTap: () {
                          if (snapshot.data == true) {
                            bloc.inRemoveFavorite.add(widget.movieCard);
                          } else {
                            bloc.inAddFavorite.add(widget.movieCard);
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              snapshot.data == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: snapshot.data == true
                                  ? Colors.red
                                  : Colors.white,
                            )),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 6.0),
          Text('Vote average: ${widget.movieCard.voteAverage}',
              style: TextStyle(
                fontSize: 12.0,
              )),
          SizedBox(height: 4.0),
          Divider(),
          Container(
            padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 8.0),
            child: Text(widget.movieCard.overview),
          ),
        ],
      ),
    );
  }
}
