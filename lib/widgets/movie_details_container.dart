import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/models/movie_card.dart';
import 'package:movies_streams/widgets/movie_details_widget.dart';

class MovieDetailsContainer extends StatefulWidget {
  MovieDetailsContainer({
    super.key,
  });

  @override
  MovieDetailsContainerState createState() => MovieDetailsContainerState();
}

class MovieDetailsContainerState extends State<MovieDetailsContainer> {
  MovieCard? _movieCard;

  set movieCard(MovieCard newMovieCard) {
    if (mounted) {
      setState(() {
        _movieCard = newMovieCard;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_movieCard == null)
        ? Center(
            child: Text('Click on a movie to see the details...'),
          )
        : MovieDetailsWidget(
            movieCard: _movieCard!,
            boxFit: BoxFit.contain,
            favoritesStream:
                BlocProvider.of<FavoriteBloc>(context)!.outFavorites,
          );
  }
}
