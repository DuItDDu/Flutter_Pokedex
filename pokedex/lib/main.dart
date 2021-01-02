import 'package:flutter/material.dart';
import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/bloc/pokemon_bloc.dart';

import 'package:pokedex/model/Pokemon.dart';

void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PokedexHomePage(),
    );
  }
}

class PokedexHomePage extends StatelessWidget {
  final PokemonBloc _bloc = PokemonBloc(PokemonApi());

  PokedexHomePage() {
    _bloc.requestPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Pokedex'),
      ),
      body: StreamBuilder(
          stream: _bloc.pokemonList,
          builder: (context, AsyncSnapshot<List<Pokemon>> snapshot) {
            return _createPokemonList(snapshot.data);
          }),
    );
  }

  Widget _createPokemonList(List<Pokemon> pokemonList) {
    if (pokemonList != null) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            return _createPokemonCard(pokemonList[index]);
          });
    } else {
      return Center();
    }
  }

  Widget _createPokemonCard(Pokemon pokemon) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              pokemon.name,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                pokemon.getImageUrl(),
                width: 100,
                height: 100,
              )
            ],
          )
        ],
      ),
    ));
  }
}
