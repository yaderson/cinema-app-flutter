import 'package:cinema_app/src/pages/home_page.dart';
import 'package:cinema_app/src/pages/movie_details.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinema App',
      debugShowCheckedModeBanner: false,
      color: Colors.red,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'details': (BuildContext context) => MovieDetails()
      },
    );
  }
}
