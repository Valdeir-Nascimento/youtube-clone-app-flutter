import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtubebloc/models/video.dart';

// const CHAVE_YOUTUBE_API = "AIzaSyD38aAlwCMA3YFP4o9QK8AFxLJOiwrzWtM";
const CHAVE_YOUTUBE_API = "AIzaSyDJOgalhHdjneGo74qJhha-F4okrOd4YSM";

/*
"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"

"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"

"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

 */
class Api {
  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$CHAVE_YOUTUBE_API&maxResults=10");

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);

      _nextToken = dadosJson["nextPageToken"];

      //Convertendo map em Video
      List<Video> videos = dadosJson["items"].map<Video>((map) {
        return Video.fromJson(map);
        //return Video.converterJson(map);

      }).toList();
      print("VIDEOS $videos");
      return videos;

      //print("RESPOSTA: " + resposta.body);
    } else {
      throw Exception("Deu Erro");
    }
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$CHAVE_YOUTUBE_API&maxResults=10&pageToken=$_nextToken");

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Video> videos = dadosJson["items"].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    } else {
      throw Exception("Deu Erro");
    }
  }
}
