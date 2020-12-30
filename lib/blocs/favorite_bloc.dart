import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtubebloc/models/video.dart';

class FavoriteBloc extends BlocBase {
  //Id, objetoVideo
  Map<String, Video> _favoritos = {};
  //brodcast: o mesmo stream pode ser observado por varios por varios objetos
  //BehaviorSubject ja enviar o ultimo que já passou
  final _favoriteController = BehaviorSubject<Map<String, Video>>();
  Stream<Map<String, Video>> get outFavorite => _favoriteController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favorites")) {
        //Salavando em formato json
        //Convertendo ".map" p/  um mapa (k, v)
        _favoritos = json.decode(prefs.getString("favorites")).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String,
            Video>(); //Cast pois iria retorna um map<String, dynamic>

        _favoriteController.add(_favoritos);
      }
    });
  }

  void toggleFavorite(Video video) {
    if (_favoritos.containsKey(video.id)) {
      _favoritos.remove(video.id);
    } else {
      //Adicionando o video no mapa
      _favoritos[video.id] = video;
    }
    _favoriteController.sink.add(_favoritos);

    _salvarFavoritos();
  }

  void _salvarFavoritos() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favoritos));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _favoriteController.close();
  }
}
