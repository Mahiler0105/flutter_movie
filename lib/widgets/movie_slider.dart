import 'package:flutter/material.dart';
import 'package:leriet_movie/models/movie.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movie;
  final String? title;
  final VoidCallback nextPage;

  const MovieSlider(
      {Key? key, required this.movie, this.title, required this.nextPage})
      : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 500) {
        widget.nextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.movie.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int key) => _MoviePoster(widget.movie[key]),
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  const _MoviePoster(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.idHero = 'slider-${movie.id}';
    return Container(
      width: 130,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'detail', arguments: movie),
            child: Hero(
              tag: movie.idHero!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
