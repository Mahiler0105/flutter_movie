import 'package:flutter/material.dart';
import 'package:leriet_movie/providers/movies_provider.dart';
import 'package:leriet_movie/screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:page_transition/page_transition.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peliculas Lerit',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      // routes: {
      //   'home': (_) => const HomeScreen(),
      //   'detail': (_) => const DetailScreen(),
      // },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'detail':
            return PageTransition(
              child: const DetailScreen(),
              // duration: Duration(seconds: 1),
              // alignment: Alignment.center,
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          case '/':
            return PageTransition(
              child: const HomeScreen(),
              // duration: Duration(seconds: 1),
              // alignment: Alignment.center,
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          default:
            return null;
        }
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
        ),
      ),
    );
  }
}
