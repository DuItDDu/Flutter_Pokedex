import 'package:pokedex/api/pokemon_api.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:pokedex/model/Pokemon.dart';

class PokemonBloc {
  final PokemonApi _api;

  BehaviorSubject<List<Pokemon>> _pokemonList;
  Observable<List<Pokemon>> get pokemonList => _pokemonList.stream;

  BehaviorSubject<bool> _isLoading;
  Observable<bool> get isLoading => _isLoading.stream;

  PokemonBloc(this._api) {
    _pokemonList = new BehaviorSubject<List<Pokemon>>(seedValue: []);
    _isLoading = new BehaviorSubject(seedValue: false);
  }

  requestPokemonList() async {
    if (_isLoading.value) {
      return;
    }

    _isLoading.sink.add(true);

    final int limit = 20;

    List<Pokemon> current = _pokemonList.value;
    int offset = 0;

    if (current != null) {
      if (current.length > 0) {
        Pokemon lastPokemon = current.last;
        if (lastPokemon != null) {
          offset = lastPokemon.id;
        }
      }
    }

    List<Pokemon> newList =  await _api.getPokemonList(offset, limit);

    if (current != null) {
      current.addAll(newList);
      _pokemonList.sink.add(current);
    } else {
      _pokemonList.sink.add(newList);
    }

    _isLoading.sink.add(false);
  }

  void dispose() {
    _pokemonList.close();
    _isLoading.close();
  }
}