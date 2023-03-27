import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/movie_catalog_bloc.dart';
import 'package:movies_streams/pages/list.dart';
import 'package:movies_streams/pages/list_one_page.dart';
import 'package:movies_streams/widgets/favorite_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Movies')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              child: Text('Movies List'),
              onPressed: () {
                _openPage(context);
              },
            ),
            FavoriteButton(
              child: Text('Favorite Movies'),
            ),
            ElevatedButton(
              child: Text('One Page'),
              onPressed: () {
                _openOnePage(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListPage(),
      );
    }));
  }

  void _openOnePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListOnePage(),
      );
    }));
  }
}
