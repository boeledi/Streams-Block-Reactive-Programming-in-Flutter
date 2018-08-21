import 'dart:async';

import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/models/movie_card.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteMovieBloc implements BlocBase {
  ///
  /// A stream only meant to return whether THIS movie is part of the favorites
  ///
  final BehaviorSubject<bool> _isFavoriteController = BehaviorSubject<bool>();
  Stream<bool> get outIsFavorite => _isFavoriteController.stream;

  ///
  /// Stream of all the favorites
  ///
  final StreamController<List<MovieCard>> _favoritesController = StreamController<List<MovieCard>>();
  Sink<List<MovieCard>> get inFavorites => _favoritesController.sink;

  ///
  /// Constructor
  ///
  FavoriteMovieBloc(MovieCard movieCard){
    //
    // We are listening to all favorites
    //
    _favoritesController.stream
                        // but, we only consider the one that matches THIS one
                        .map((list) => list.any((MovieCard item) => item.id == movieCard.id))
                        // if any, we notify that it is part of the Favorites
                        .listen((isFavorite) => _isFavoriteController.add(isFavorite));
  }

  void dispose(){
    _favoritesController.close();
    _isFavoriteController.close();
  }
}