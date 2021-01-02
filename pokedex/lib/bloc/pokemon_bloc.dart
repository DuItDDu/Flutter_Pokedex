import 'package:pokedex/api/pokemon_api.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:pokedex/model/Pokemon.dart';

class PokemonBloc {
  final PokemonApi _api;

  BehaviorSubject<List<Pokemon>> _pokemonList;
  Observable<List<Pokemon>> get pokemonList => _pokemonList.stream;

  PokemonBloc(this._api) {
    _pokemonList = new BehaviorSubject<List<Pokemon>>(seedValue: []);
  }

  requestPokemonList() async {
    List<Pokemon> newList =  await _api.getPokemonList(0, 151);
    _pokemonList.sink.add(newList);
  }

  void dispose() {
    _pokemonList.close();
  }
}