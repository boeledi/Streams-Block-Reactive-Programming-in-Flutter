import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/models/movie_card.dart';
import 'package:movies_streams/widgets/movie_details_widget.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({
    super.key,
    required this.data,
  });

  final MovieCard data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: MovieDetailsWidget(
        movieCard: data,
        favoritesStream: BlocProvider.of<FavoriteBloc>(context)!.outFavorites,
      ),
    );
  }
}
