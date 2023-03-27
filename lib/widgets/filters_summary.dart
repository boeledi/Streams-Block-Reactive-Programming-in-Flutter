import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/movie_catalog_bloc.dart';

class FiltersSummary extends StatelessWidget {
  FiltersSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
//    final MovieGenre? genre = ApplicationProvider.of(context).genres.firstWhere((g) => g.genre == data.genre);
    final MovieCatalogBloc movieBloc =
        BlocProvider.of<MovieCatalogBloc>(context)!;

    return Container(
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<int>(
            stream: movieBloc.outGenre,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Text('Genre: ${snapshot.data}');
            },
          ),
          StreamBuilder<List<int>>(
            stream: movieBloc.outReleaseDates,
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.hasData) {
                return Text(
                    'Years: [${snapshot.data![0]} - ${snapshot.data![1]}]');
              }
              return Container();
            },
          ),
          StreamBuilder<int>(
            stream: movieBloc.outTotalMovies,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Text('Total: ${snapshot.data}');
            },
          ),
        ],
      ),
    );
  }
}
