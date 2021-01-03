import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pokedex/model/Pokemon.dart';

class PokemonApi {
  final http.Client _client = http.Client();
  static const String _baseUrl = "pokeapi.co";

  Future<List<Pokemon>> getPokemonList(int offset, int limit) async {
    List<Pokemon> pokemonList = [];

    Map<String, String> params = {
      'offset': offset.toString(),
      'limit': limit.toString()
    };
    Uri uri = Uri.https(_baseUrl, '/api/v2/pokemon', params);

    await _client.get(uri).then((res) {
      return jsonDecode(res.body);
    }).then((json) async {
      dynamic results = json["results"];

      if (results is List) {
        for (var i = 0; i < results.length; i++) {
          String url = results[i]['url'];
          Pokemon pokemon = await getPokemon(url);
          if (pokemon != null) {
            pokemonList.add(pokemon);
          }
        }
      }
    });

    return pokemonList;
  }

  Future<Pokemon> getPokemon(String url) async {
    return await _client.get(Uri.parse(url)).then((res) {
      return jsonDecode(res.body);
    }).then((json) {
      return Pokemon.fromJson(json);
    });
  }
}
