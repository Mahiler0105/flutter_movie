import 'package:flutter/material.dart';
import 'package:leriet_movie/providers/movies_provider.dart';
import 'package:leriet_movie/search/search_delegate.dart';
import 'package:leriet_movie/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas App'),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(
              Icons.search_outlined,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            MovieSlider(
              title: "Popular",
              movie: moviesProvider.onDisplayPopular,
              nextPage: moviesProvider.getPopularMovies,
            ),
          ],
        ),
      ),
    );
  }
}
