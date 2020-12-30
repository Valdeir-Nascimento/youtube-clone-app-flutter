import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtubebloc/blocs/favorite_bloc.dart';
import 'package:youtubebloc/blocs/videos_bloc.dart';
import 'package:youtubebloc/delegates/data_search.dart';
import 'package:youtubebloc/models/video.dart';
import 'package:youtubebloc/views/favorites_page.dart';
import 'package:youtubebloc/widget/video_tile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videoBloc = BlocProvider.getBloc<VideosBloc>();
    final favoritoBloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("assets/imagens/youtube.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: favoritoBloc.outFavorite,
              initialData: {}, //Mapa vazio
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data.length}");
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String resultado =
                    await showSearch(context: context, delegate: DataSearch());

                if (resultado != null) {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(resultado);
                }
              }),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(video: snapshot.data[index]);
                } else if (index > 1) {
                  //adicionamos null pq queremos apenas ir para a proxima página
                  videoBloc.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
