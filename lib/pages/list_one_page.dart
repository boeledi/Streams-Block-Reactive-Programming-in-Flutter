import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/blocs/movie_catalog_bloc.dart';
import 'package:movies_streams/models/movie_card.dart';
import 'package:movies_streams/pages/filters.dart';
import 'package:movies_streams/widgets/favorite_button.dart';
import 'package:movies_streams/widgets/filters_summary.dart';
import 'package:movies_streams/widgets/movie_card_widget.dart';
import 'package:movies_streams/widgets/movie_details_container.dart';

class ListOnePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MovieDetailsContainerState> _movieDetailsKey =
      GlobalKey<MovieDetailsContainerState>();

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc =
        BlocProvider.of<MovieCatalogBloc>(context)!;
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context)!;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('List One Page'),
        actions: <Widget>[
          // Icon that gives direct access to the favorites
          // It also displays "real-time" the number of favorites
          FavoriteButton(
            child: const Icon(Icons.favorite),
          ),
          // Icon to open the filters
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Displays the filters currently being defined
          FiltersSummary(),
          Container(
            height: 150.0,
            // Horizontal list of all movies in the catalog
            // based on the filters
            child: StreamBuilder<List<MovieCard>>(
                stream: movieBloc.outMoviesList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<MovieCard>> snapshot) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildMovieCard(movieBloc, index, snapshot.data!,
                          favoriteBloc.outFavorites);
                    },
                    itemCount:
                        (snapshot.data == null ? 0 : snapshot.data!.length) +
                            30,
                  );
                }),
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              // Container to show the details related to a movie,
              // selected by the user
              child: MovieDetailsContainer(
                key: _movieDetailsKey,
              ),
            ),
          ),
        ],
      ),
      endDrawer: FiltersPage(),
    );
  }

  Widget _buildMovieCard(MovieCatalogBloc movieBloc, int index,
      List<MovieCard>? movieCards, Stream<List<MovieCard>> favoritesStream) {
    // Notify the MovieCatalogBloc that we are rendering the MovieCard[index]
    movieBloc.inMovieIndex.add(index);

    // Get the MovieCard data
    MovieCard? movieCard = (movieCards != null && movieCards.length > index)
        ? movieCards[index]
        : null;

    // If the movie card is not yet available, display a progress indicator
    if (movieCard == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Otherwise, display the movie card
    return SizedBox(
      width: 150.0,
      child: MovieCardWidget(
        key: Key('movie_${movieCard.id}'),
        movieCard: movieCard,
        favoritesStream: favoritesStream,
        noHero: true,
        onPressed: () {
          _movieDetailsKey.currentState?.movieCard = movieCard;
        },
      ),
    );
  }
}
