import 'dart:async';
import 'dart:collection';

import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/models/movie_card.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteBloc implements BlocBase {
  ///
  /// Unique list of all favorite movies
  ///
  final Set<MovieCard> _favorites = Set<MovieCard>();

  // ##########  STREAMS  ##############
  ///
  /// Interface that allows to add a new favorite movie
  ///
  final BehaviorSubject<MovieCard> _favoriteAddController =
      BehaviorSubject<MovieCard>();
  Sink<MovieCard> get inAddFavorite => _favoriteAddController.sink;

  ///
  /// Interface that allows to remove a movie from the list of favorites
  ///
  final BehaviorSubject<MovieCard> _favoriteRemoveController =
      BehaviorSubject<MovieCard>();
  Sink<MovieCard> get inRemoveFavorite => _favoriteRemoveController.sink;

  ///
  /// Interface that allows to get the total number of favorites
  ///
  final BehaviorSubject<int> _favoriteTotalController =
      BehaviorSubject<int>.seeded(0);
  Sink<int> get _inTotalFavorites => _favoriteTotalController.sink;
  Stream<int> get outTotalFavorites => _favoriteTotalController.stream;

  ///
  /// Interface that allows to get the list of all favorite movies
  ///
  final BehaviorSubject<List<MovieCard>> _favoritesController =
      BehaviorSubject<List<MovieCard>>.seeded([]);
  Sink<List<MovieCard>> get _inFavorites => _favoritesController.sink;
  Stream<List<MovieCard>> get outFavorites => _favoritesController.stream;

  ///
  /// Constructor
  ///
  FavoriteBloc() {
    _favoriteAddController.listen(_handleAddFavorite);
    _favoriteRemoveController.listen(_handleRemoveFavorite);
  }

  void dispose() {
    _favoriteAddController.close();
    _favoriteRemoveController.close();
    _favoriteTotalController.close();
    _favoritesController.close();
  }

  // ############# HANDLING  #####################

  void _handleAddFavorite(MovieCard movieCard) {
    // Add the movie to the list of favorite ones
    _favorites.add(movieCard);

    _notify();
  }

  void _handleRemoveFavorite(MovieCard movieCard) {
    _favorites.remove(movieCard);

    _notify();
  }

  void _notify() {
    // Send to whomever is interested...
    // The total number of favorites
    _inTotalFavorites.add(_favorites.length);

    // The new list of all favorite movies
    _inFavorites.add(UnmodifiableListView(_favorites));
  }
}
