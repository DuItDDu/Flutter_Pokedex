
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/app/ui/widgets/EmptyWidget.dart';
import 'package:pokedex/model/Pokemon.dart';

class _PokedexDetailPageState extends State<PokedexDetailPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final Pokemon _pokemon;
  Color _pokemonColor;

  AudioCache _audioPlayer = AudioCache();
  AudioPlayer _player = AudioPlayer();
  WidgetsBinding _binding = WidgetsBinding.instance;

  _PokedexDetailPageState(this._pokemon);

  @override
  void initState() {
    super.initState();
    _pokemonColor = _pokemon.getPrimaryColor();
    AudioPlayer.logEnabled = false;
    _playAudio();
    _binding.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _stopAudio();
    _binding.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _createPokedexDetailAppBar(_pokemon),
      body: SafeArea(
        child: Container(
          color: _pokemonColor,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
          child: _createPokedexDetailBody(_pokemon),
        ),
      )
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        _playAudio();
        break;
      case AppLifecycleState.inactive:
        _stopAudio();
        break;
      default:
        break;
    }
  }

  void _playAudio() async {
    _player = await _audioPlayer.loop("pokedex_detail.mp3");
  }

  void _stopAudio() {
    _player?.stop();
  }


  Widget _createPokedexDetailAppBar(Pokemon pokemon) {
    return AppBar(
      backgroundColor: _pokemonColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _pokemon.name,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "#${_pokemon.id.toString().padLeft(3, "0")}",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget _createPokedexDetailBody(Pokemon pokemon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _createPokedexDetailHeader(pokemon),
        Expanded(child: _createPokemonDetailSheet(pokemon))
      ],
    );
  }

  Widget _createPokedexDetailHeader(Pokemon pokemon) {
    return Column(
      children: [
        _createPokemonImageRow(pokemon),
      ],
    );
  }

  Widget _createPokemonImageRow(Pokemon pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _createPokemonImage(pokemon),
        _createOakImage()
      ],
    );
  }

  Widget _createPokemonImage(Pokemon pokemon) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SvgPicture.asset(
          'assets/pokeball.svg',
          color: Colors.white54,
          width: 200,
          height: 200,
        ),
        FadeInImage(
            width: 150,
            height: 150,
            placeholder: AssetImage('assets/pokemon_placeholder.png'),
            image: NetworkImage(pokemon.imageUrl)
        )
      ],
    );
  }

  Widget _createOakImage() {
    return Image.asset(
      "assets/pokemon_oak.png",
      width: 150,
      height: 200,
    );
  }

  Widget _createPokemonDetailSheet(Pokemon pokemon) {
    return Card(
        margin: EdgeInsets.only(left: 0.0, top: 16.0, right: 0.0, bottom: 0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36.0),
                topRight: Radius.circular(36.0)
            )
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _createPokemonTypeRow(pokemon),
                      _createPokemonSizeRow(pokemon),
                      _createPokemonStatsRow(pokemon.stats),
                    ],
                  )
              )
            ],
          ),
        )
    );
  }

  Widget _createPokemonTypeRow(Pokemon pokemon) {
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: pokemon.types.map((type) =>
            _createPokemonTypeCard(type)
        ).toList()
      ),
    );
  }

  Widget _createPokemonTypeCard(PokemonType type) {
    return Card(
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: type.getTypeColor(),
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
          child: Text(
            type.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white
            ),
          ),
        )
    );
  }

  Widget _createPokemonSizeRow(Pokemon pokemon) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createPokemonSizeCard("Weight", pokemon.weight.toDouble(), "KG"),
          _createPokemonSizeCard("Height", pokemon.height.toDouble(), "M")
        ],
      ),
    );
  }

  Widget _createPokemonSizeCard(String name, double size, String unit) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$size $unit",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _createPokemonStatsRow(List<PokemonStat> stats) {
    if (stats == null) {
      return EmptyWidget();
    } else {
      List<Widget> widgets = [Container(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(
          "Pokemon Stats",
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.black87
          ),
        ),
      )
      ];

      stats.forEach((stat) {
        String name = stat.convertName();
        if (name.isNotEmpty) {
          widgets.add(_createPokemonStatRow(name, stat.baseStat, 150));
        }
      });

      return Container(
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
            children: widgets
        ),
      );
    }
  }

  Widget _createPokemonStatRow(String statName, int value, int maxValue) {
    return Container(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
            statName,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black54,
            ),
          ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
              ),
          ),
          Expanded(
              flex: 6,
              child: Container(
                  padding: EdgeInsets.only(left: 4.0),
                  child: LinearProgressIndicator(
                    value: value.toDouble()/maxValue.toDouble(),
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(_pokemonColor),
                  )
              )
          )
        ],
      ),
    );
  }
}

class PokedexDetailPage extends StatefulWidget {
  final Pokemon pokemon;

  PokedexDetailPage({Key key, @required this.pokemon}): super(key: key);

  @override
  _PokedexDetailPageState createState() => _PokedexDetailPageState(pokemon);
}