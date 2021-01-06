import 'package:flutter/material.dart';
import 'package:pokedex/app/pokedex/pokedex.dart';
import 'package:pokedex/app/splash/splash.dart';

void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: 'Flutter Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}




