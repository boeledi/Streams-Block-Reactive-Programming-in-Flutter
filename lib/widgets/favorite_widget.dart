import 'package:flutter/material.dart';
import 'package:movies_streams/api/tmdb_api.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/models/movie_card.dart';

class FavoriteWidget extends StatelessWidget {
  FavoriteWidget({
    super.key,
    required this.data,
  });

  final MovieCard data;

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.black54,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 100.0,
          height: 100.0,
          child: Image.network(api.imageBaseUrl + data.posterPath,
              fit: BoxFit.contain),
        ),
        title: Text(data.title),
        subtitle: Text(data.overview, style: TextStyle(fontSize: 10.0)),
        trailing: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            bloc.inRemoveFavorite.add(data);
          },
        ),
      ),
    );
  }
}
