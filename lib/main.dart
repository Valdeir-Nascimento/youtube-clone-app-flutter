import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtubebloc/blocs/favorite_bloc.dart';
import 'package:youtubebloc/blocs/videos_bloc.dart';
import 'package:youtubebloc/views/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => VideosBloc()),
        Bloc((i) => FavoriteBloc()),
      ],
      child: MaterialApp(
        title: "Youtube",
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
