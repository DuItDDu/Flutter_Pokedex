
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/app/ui/widgets/EmptyWidget.dart';
import 'package:pokedex/model/Pokemon.dart';

class _PokedexDetailPageState extends State<PokedexDetailPage> with SingleTickerProviderStateMixin {
  final Pokemon _pokemon;
  TabController _tabController;

  List<String> _tabs;

  _PokedexDetailPageState(this._pokemon);

  @override
  void initState() {
    super.initState();
    _tabs = ["About", "Abilities", "Stats", "Games"];
    _tabController = new TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: _pokemon.getTypeColor(),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
        child: _createPokedexDetailBody(_pokemon),
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
        _createPokedexDetailLabel(pokemon),
        _createPokemonImageRow(pokemon),
      ],
    );
  }

  Widget _createPokedexDetailLabel(Pokemon pokemon) {
    return Card(
        margin: EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "#${pokemon.id.toString().padLeft(3, "0")}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: pokemon.getTypeColor(),
                      fontSize: 24.0),
                ),
                Container(width: 16.0,),
                Text(
                  pokemon.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: pokemon.getTypeColor(),
                      fontSize: 24.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
        )
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _createPokemonDetailInfoTabBar(),
                    _createPokemonDetailInfo(pokemon)
                  ],
                )
            )
          ],
        )
    );
  }

  Widget _createPokemonDetailInfoTabBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(color: Colors.white70),
      child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: _tabs
              .map(
                (tab) => Tab(
                  child: Text(
                    tab,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0
                    ),
                  ),
                ),
              )
              .toList()
      ),
    );
  }

  Widget _createPokemonDetailInfo(Pokemon pokemon) {
    return Container(

    );
  }
}

class PokedexDetailPage extends StatefulWidget {
  final Pokemon pokemon;

  PokedexDetailPage({Key key, @required this.pokemon}): super(key: key);

  @override
  _PokedexDetailPageState createState() => _PokedexDetailPageState(pokemon);
}