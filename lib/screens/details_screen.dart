import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leriet_movie/models/movie.dart';
import 'package:leriet_movie/widgets/widgets.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _scrollController = ScrollController();

  double _marginLeft = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          if (_marginLeft <= 50) _marginLeft++;
        });
      } else {
        setState(() {
          if (_marginLeft > 0) _marginLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _CustomAppBar(
              title: movie.title,
              image: movie.fullBackdropPath,
              marginLeft: _marginLeft),
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(
              id: movie.idHero!,
              image: movie.fullPosterImg,
              title: movie.title,
              originalTitle: movie.originalTitle,
              average: movie.voteAverage,
            ),
            _Overview(overView: movie.overview),
            _Overview(overView: movie.overview),
            _Overview(overView: movie.overview),
            _Overview(overView: movie.overview),
            CastingCards(movieId: movie.id),
          ])),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String title;
  final String image;
  final double marginLeft;

  const _CustomAppBar(
      {Key? key,
      required this.title,
      required this.image,
      required this.marginLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          color: Colors.black26,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Container(
              margin: EdgeInsets.only(left: marginLeft),
              child: Text(title),
              // color: Colors.red,
            ),
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage("assets/loading.gif"),
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String title;
  final String originalTitle;
  final String image;
  final double average;
  final String id;

  const _PosterAndTitle(
      {Key? key,
      required this.id,
      required this.title,
      required this.originalTitle,
      required this.image,
      required this.average})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: <Widget>[
          Hero(
            tag: id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage("assets/no-image.jpg"),
                image: NetworkImage(image),
                height: 150,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_outline,
                        size: 15, color: Colors.grey),
                    Text(average.toString(), style: textTheme.caption)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String overView;
  const _Overview({Key? key, required this.overView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        overView,
        textAlign: TextAlign.justify,
        style: textTheme.subtitle1,
      ),
    );
  }
}
