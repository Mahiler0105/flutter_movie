import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:leriet_movie/models/credits_response.dart';
import 'package:leriet_movie/models/movie.dart';
import 'package:leriet_movie/models/now_playing_response.dart';
import 'package:leriet_movie/models/popular_response.dart';
import 'package:leriet_movie/models/search_movie_response.dart';
import 'package:leriet_movie/search/debouncer.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '808767908eacee8a687bd487d957e2a8';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  String lastQuery = "";
  late List<Movie> onDisplayMovies = [];
  late List<Movie> onDisplayPopular = [];
  late List<Movie> onSearchMovie = [];

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  int _popularPage = 0;
  Map<int, List<Cast>> movieCast = {};

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint,
      [int page = 1, String query = '']) async {
    var url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
      'query': query
    });

    final response = await http.get(url);
    return response.body;
  }

  void getOnDisplayMovies() async {
    final jsonData = await _getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  void getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromRawJson(jsonData);
    onDisplayPopular = [...onDisplayPopular, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Movie>> getSearchMovies(String query) async {
    final jsonData = await _getJsonData('/3/search/movie', 1, query);
    final searchMovieResponse = SearchMovieResponse.fromRawJson(jsonData);
    onSearchMovie = searchMovieResponse.results;
    lastQuery = query;
    return searchMovieResponse.results;
  }

  Future<List<Cast>> getCastMovie(int idMovie) async {
    if (movieCast[idMovie] == null) {
      final jsonData = await _getJsonData('/3/movie/$idMovie/credits');
      final creditsResponse = CreditsResponse.fromRawJson(jsonData);
      movieCast = {...movieCast, idMovie: creditsResponse.cast};
      return creditsResponse.cast;
    }
    return movieCast[idMovie]!;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = "";
    debouncer.onValue = (value) async {
      final results = await getSearchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }

  // Future<List<Cast>> getCastMovie(int idMovie) async {
  //   if (movieCast.containsKey(idMovie)) return movieCast[idMovie]!;
  //   final jsonData = await _getJsonData('/3/movie/$idMovie/credits');
  //   final creditsResponse = CreditsResponse.fromRawJson(jsonData);
  //   movieCast[idMovie] = creditsResponse.cast;
  //   return creditsResponse.cast;
  // }
}
