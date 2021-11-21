import 'package:flutter/material.dart';
import 'package:leriet_movie/models/credits_response.dart';
import 'package:leriet_movie/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  const CastingCards({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
        future: movieProvider.getCastMovie(movieId),
        builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 190,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final List<Cast> cast = snapshot.data!;

          return Container(
            margin: const EdgeInsets.only(bottom: 30),
            height: 190,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int key) => _CastCard(cast: cast[key]),
              itemCount: cast.length,
            ),
          );
        });
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;

  const _CastCard({Key? key, required this.cast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage("assets/no-image.jpg"),
              image: NetworkImage(cast.fullProfilePath),
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            cast.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
