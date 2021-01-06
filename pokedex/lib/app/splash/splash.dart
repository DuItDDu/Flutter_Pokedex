import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/app/pokedex/pokedex.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  AudioCache _audioPlayer = AudioCache();
  AudioPlayer _player = AudioPlayer();

  WidgetsBinding _binding = WidgetsBinding.instance;

  @override
  void initState() {
    super.initState();
    AudioPlayer.logEnabled = false;
    _playSplashAudio();
    _binding.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _binding.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
              color: Colors.white,
              padding:
              EdgeInsets.only(top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Column(
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
                            height: MediaQuery.of(context).size.height - 400,
                            fit: BoxFit.fitHeight,
                          ),
                          _createStartPokedexButton(),
                        ],
                      )
                  )
                ],
              )
          ),
        )
    );
  }

  Widget _createStartPokedexButton() {
    return RaisedButton(
      color: Colors.red,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0)
      ),
      child: Container(
          width: 250,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Pokdex",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.white,)
            ],
          )
      ),
      onPressed: () => _startPokedex(),
    );
  }

  void _startPokedex() {
    _stopSplashAudio();
    
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PokedexPage()
        )
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        _playSplashAudio();
        break;
      case AppLifecycleState.inactive:
        _stopSplashAudio();
        break;
      default:
        break;
    }
  }

  void _playSplashAudio() async {
    _player = await _audioPlayer.loop("splash.mp3");
  }

  void _stopSplashAudio() {
    _player?.stop();
  }
}