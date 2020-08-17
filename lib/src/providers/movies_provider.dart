import 'dart:convert';
import 'dart:async';
import 'package:cinema_app/src/models/actors_model.dart';
import 'package:cinema_app/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apiKey  = '42f466ffb2d5fe7abb3db69879499883';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _pupularsPage = 0;
  bool loading = false;

  List<Movie> _populars = new List();

  final _populasStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSinck => _populasStreamController.sink.add;

  Stream <List<Movie>> get popularsStream => _populasStreamController.stream;

  void disposeStreams() {
    _populasStreamController?.close();
  }

  Future <List<Movie>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final movies = new Movies.formJsonList(decodedData['results']);
    return movies.items;
  }

  Future <List<Movie>>getInCine() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language
    });

    return await _processResponse(url);
    
  }

  Future <List<Movie>>getPopulars() async {
  
    if(loading) return [];
    _pupularsPage++;
    print('Get Populars...');
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _pupularsPage.toString()
    });
    
    final response = await _processResponse(url);
    _populars.addAll(response);
    popularsSinck(_populars);

    return response;
  }

  Future <List<Actor>> getActors (String movieId) async {
    final url = Uri.https(_url,'3/movie/$movieId/credits',{
      'api_key': _apiKey,
      'language': _language
    });

    final response = await http.get(url);
    final decodeData = json.decode(response.body);
    
    final cast = new Actors.formJsonList(decodeData['cast']);
    return cast.items;

  }

  Future <List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
      'page': '1' 
    });

    return await _processResponse(url);
    
  }
}