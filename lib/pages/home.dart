import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/blocs/movie_catalog_bloc.dart';
import 'package:movies_streams/pages/favorites.dart';
import 'package:movies_streams/pages/list.dart';
import 'package:movies_streams/pages/list_one_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Movies')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Movies List'),
              onPressed: () {
                _openPage(context);
              },
            ),
            _buildButtonFavoriteMovies(context),
            RaisedButton(
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

  //
  // Builds the button which redirects to the list of Favorite Movies
  // This button displays a "badge" to indicate the number of favorite Movies
  //
  Widget _buildButtonFavoriteMovies(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        RaisedButton(
          child: Text('Favorite Movies'),
          onPressed: () {
            _openPageFavorites(context);
          },
        ),
        Positioned(
          top: -8.0,
          right: -8.0,
          child: IgnorePointer(
            child: Container(
              width: 32.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1.0),
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: StreamBuilder(
                        stream: bloc.outTotalFavorites,
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapshot) {
                          return Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openPage(BuildContext context) {
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListPage(),
      );
    }));
  }

  void _openOnePage(BuildContext context) {
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListOnePage(),
      );
    }));
  }

  void _openPageFavorites(BuildContext context) {
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return FavoritesPage();
    }));
  }
}
