import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/application_bloc.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/movie_catalog_bloc.dart';
import 'package:movies_streams/models/movie_filters.dart';
import 'package:movies_streams/models/movie_genre.dart';

typedef FiltersPageCallback(MovieFilters result);

class FiltersPage extends StatefulWidget {
  FiltersPage({
    super.key,
  });

  @override
  FiltersPageState createState() => FiltersPageState();
}

class FiltersPageState extends State<FiltersPage> {
  late ApplicationBloc _appBloc;
  late MovieCatalogBloc _movieBloc;
  late double _minReleaseDate;
  late double _maxReleaseDate;
  MovieGenre? _movieGenre;
  List<MovieGenre>? _genres;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // As the context of not yet available at initState() level,
    // if not yet initialized, we get the list of all genres
    // and retrieve the currently selected one, as well as the
    // filter parameters
    if (_isInit == false) {
      _appBloc = BlocProvider.of<ApplicationBloc>(context)!;
      _movieBloc = BlocProvider.of<MovieCatalogBloc>(context)!;

      _getFilterParameters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isInit == false
        ? Container()
        : Scaffold(
            appBar: AppBar(
              leading: Container(),
              title: Text('Filters'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Release dates range selector

                  Text(
                    'Years:',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 40.0,
                            maxWidth: 40.0,
                          ),
                          child: Text('${_minReleaseDate.toStringAsFixed(0)}'),
                        ),
                        Expanded(
                          child: RangeSlider(
                            min: 2000.0,
                            max: 2017.0,
                            values:
                                RangeValues(_minReleaseDate, _maxReleaseDate),
                            divisions: 18,
                            onChanged: (RangeValues? values) {
                              if (mounted) {
                                setState(() {
                                  _minReleaseDate = values!.start;
                                  _maxReleaseDate = values.end;
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 40.0,
                            maxWidth: 40.0,
                          ),
                          child: Text('${_maxReleaseDate.toStringAsFixed(0)}'),
                        ),
                      ],
                    ),
                  ),

                  Divider(),

                  // Genre Selector

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Genre:'),
                      SizedBox(width: 24.0),
                      DropdownButton<MovieGenre>(
                        items: _genres?.map((MovieGenre movieGenre) {
                          return DropdownMenuItem<MovieGenre>(
                            value: movieGenre,
                            child: Text(movieGenre.text),
                          );
                        }).toList(),
                        value: _movieGenre,
                        onChanged: (MovieGenre? newMovieGenre) {
                          _movieGenre = newMovieGenre!;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filters acceptance

            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                //
                // When the user accepts the changes to the filters,
                // we need to send the new filters to the MovieCatalogBloc filters sink.
                //
                _movieBloc.inFilters.add(MovieFilters(
                  minReleaseDate: _minReleaseDate.round(),
                  maxReleaseDate: _maxReleaseDate.round(),
                  genre: _movieGenre!.genre,
                ));

                // close the screen
                Navigator.of(context).pop();
              },
            ),
          );
  }

  ///
  /// Very tricky.
  ///
  /// As we want to be 100% BLoC compliant, we need to retrieve
  /// everything from the BLoCs, using Streams...
  ///
  /// This is ugly but to be considered as a study case.
  ///
  void _getFilterParameters() {
    StreamSubscription? subscriptionMovieGenres;
    StreamSubscription? subscriptionFilters;

    subscriptionMovieGenres =
        _appBloc.outMovieGenres.listen((List<MovieGenre>? data) {
      _genres = data ?? [];

      subscriptionFilters =
          _movieBloc.outFilters.listen((MovieFilters filters) {
        _minReleaseDate = filters.minReleaseDate.toDouble();
        _maxReleaseDate = filters.maxReleaseDate.toDouble();
        _movieGenre = _genres!.firstWhere((g) => g.genre == filters.genre);

        // Simply to make sure the subscriptions are released
        subscriptionMovieGenres?.cancel();
        subscriptionFilters?.cancel();

        // Now that we have all parameters, we may build the actual page
        if (mounted) {
          setState(() {
            _isInit = true;
          });
        }
      });
    });

    // Send a request to get the list of the movie genres via stream
    _appBloc.getMovieGenres.add(null);
  }
}
