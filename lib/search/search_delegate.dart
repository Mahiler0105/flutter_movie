import 'package:flutter/material.dart';
import 'package:leriet_movie/models/movie.dart';
import 'package:leriet_movie/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => "Buscar película";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("BUILD RESULT");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 130,
        ),
      );
    }
    final moviesProvider = Provider.of<MoviesProvider>(context);
    moviesProvider.getSuggestionByQuery(query);
    return StreamBuilder(
        stream: moviesProvider.suggestionStream,
        initialData: moviesProvider.onSearchMovie,
        builder: (_, AsyncSnapshot<List<Movie>> snap) {
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Movie> movies = snap.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, int key) {
                return _SearchItemMovie(movie: movies[key]);
              });
        });
  }
}

class _SearchItemMovie extends StatelessWidget {
  final Movie movie;
  const _SearchItemMovie({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.idHero = 'search-${movie.id}';
    return ListTile(
      title: Text(movie.title),
      leading: Hero(
        tag: movie.idHero!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            image: NetworkImage(movie.fullPosterImg),
            placeholder: const AssetImage("assets/no-image.jpg"),
            width: 50,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
      subtitle: Text(movie.originalTitle),
      onTap: () => Navigator.pushNamed(context, 'detail', arguments: movie),
    );
  }
}
