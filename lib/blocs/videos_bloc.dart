import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtubebloc/models/video.dart';
import 'package:youtubebloc/services/api.dart';

class VideosBloc extends BlocBase {
  Api api;
  List<Video> videos;

  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();
  final StreamController<String> _searchController = StreamController<String>();

  Stream get outVideos => _videosController.stream;
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = new Api();

    _searchController.stream.listen(_search);
  }

  void _search(String pesquisar) async {
    //print(pesquisar);
    //print(videos);

    if (pesquisar != null) {
      _videosController.sink.add([]);
      videos = await api.search(pesquisar);
    } else {
      videos += await api.nextPage();
    }
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }
}
