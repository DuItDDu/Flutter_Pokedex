import 'dart:ui';

import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/model/PokemonGeneration.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:pokedex/model/Pokemon.dart';

class PokemonBloc {
  static const int DEFAULT_LIMIT = 20;

  final PokemonApi _api;
  final List<PokemonGeneration> generations = [
    PokemonGeneration(1, "관동", 1, 151, Color(0xFFff7961)),
    PokemonGeneration(2, "성도", 152, 251, Color(0xFF60ad5e)),
    PokemonGeneration(3, "호연", 252, 386, Color(0xFFff77a9)),
    PokemonGeneration(4, "신오", 387, 493, Color(0xFF42a5f5)),
    PokemonGeneration(5, "하나", 494, 649, Color(0xFF424242)),
    PokemonGeneration(6, "칼로스", 650, 721, Color(0xFF8187ff)),
    PokemonGeneration(7, "알로라", 722, 809, Color(0xFFff9d3f)),
    PokemonGeneration(8, "가라르", 810, 898, Color(0xFFae52d4)),
  ];

  BehaviorSubject<List<Pokemon>> _pokemonList;
  Observable<List<Pokemon>> get pokemonList => _pokemonList.stream;

  BehaviorSubject<PokemonGeneration> _generation;
  Observable<PokemonGeneration> get generation => _generation.stream;

  BehaviorSubject<bool> _isLoading;
  Observable<bool> get isLoading => _isLoading.stream;

  int _offset = 0;

  PokemonBloc(this._api) {
    _pokemonList = new BehaviorSubject<List<Pokemon>>(seedValue: []);
    _isLoading = new BehaviorSubject(seedValue: false);
    _generation = new BehaviorSubject(seedValue: generations.first);
    _offset = generations.first.start - 1;
  }

  requestPokemonList() async {
    PokemonGeneration generation = _generation.value != null ? _generation.value : generations.first;
    await _requestPokemonListInGeneration(generation);
  }

  _requestPokemonListInGeneration(PokemonGeneration generation) async {
    if (_offset >= generation.end) { return; }
    if (_isLoading.value) { return; }

    _isLoading.sink.add(true);

    int limit = DEFAULT_LIMIT;

    PokemonGeneration current = _generation.value;
    bool isNewGeneration = current.number != generation.number;
    if (isNewGeneration) {
      _offset = generation.start - 1;
      _generation.sink.add(generation);
      _pokemonList.sink.add([]);
    } else {
      int endOffset = _offset + DEFAULT_LIMIT;
      if (endOffset > generation.end) {
        limit = generation.end - _offset;
      }
    }

    List<Pokemon> newList = await _api.getPokemonList(_offset, limit);
    await _sinkPokemonList(newList, isNewGeneration);

    _offset = _offset + limit;
    _isLoading.sink.add(false);
  }

  Future _sinkPokemonList(List<Pokemon> newList, bool isNewGeneration) async {
    if (isNewGeneration) {
      _pokemonList.sink.add(newList);
    } else {
      List<Pokemon> current = _pokemonList.value;

      if (current != null) {
        current.addAll(newList);
        _pokemonList.sink.add(current);
      } else {
        _pokemonList.sink.add(newList);
      }
    }
  }

  void onGenerationClick(PokemonGeneration generation) {
    _requestPokemonListInGeneration(generation);
  }

  void dispose() {
    _pokemonList.close();
    _isLoading.close();
    _generation.close();
  }
}