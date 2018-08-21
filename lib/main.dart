import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_streams/blocs/application_bloc.dart';
import 'package:movies_streams/blocs/bloc_provider.dart';
import 'package:movies_streams/blocs/favorite_bloc.dart';
import 'package:movies_streams/pages/home.dart';

Future<void> main() async {
//  debugPrintRebuildDirtyWidgets = true;
  return runApp(
    BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider<FavoriteBloc>(
        bloc: FavoriteBloc(),
        child: MyApp(),
      ),
    )
  );
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
