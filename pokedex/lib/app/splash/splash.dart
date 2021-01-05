
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/pokemon_banner.jpg",
                      width: double.infinity,
                      height: 200,
                    ),
                    Image.asset(
                      "assets/pokemon_red.png",
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 350,
                      fit: BoxFit.fitHeight,
                    )
                  ],
                )
                )
              ],
            )
          ),
        )
    );
  }
}