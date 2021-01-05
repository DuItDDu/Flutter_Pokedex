import 'dart:ui';

const Color defaultColor = Color(0xFF58ABF6);

class Pokemon {
  final int id;
  final String name;
  final int height, weight;
  final String imageUrl;
  final List<PokemonType> types;
  final List<PokemonStat> stats;

  Pokemon(
      this.id,
      this.name,
      this.height,
      this.weight,
      this.imageUrl,
      this.types,
      this.stats
      );

  Pokemon.fromJson(Map json)
      : this.id = json['id'],
        this.name = json['name'],
        this.height = json['height'],
        this.weight = json['weight'],
        this.imageUrl =
            "https://pokeres.bastionbot.org/images/pokemon/${json['id']}.png",
        this.types = (json['types'] as List).map((e) {
          return PokemonType.fromJson(e);
        }).toList(),
        this.stats = (json['stats'] as List).map((e) {
          return PokemonStat.fromJson(e);
        }).toList();

  Color getPrimaryColor() {
    if (types.isNotEmpty) {
      return types.first.getTypeColor();
    }

    return defaultColor;
  }
}

class PokemonType {
  final int slot;
  final String name;
  final String typeUrl;

  PokemonType(this.slot, this.name, this.typeUrl);

  PokemonType.fromJson(Map json)
      : this.slot = json['slot'],
        this.name = json['type']['name'],
        this.typeUrl = json['type']['url'];

  Color getTypeColor() {
    Color typeColor = defaultColor;

    switch (name.toLowerCase()) {
      case "grass":
        typeColor = Color(0xFF2CDAB1);
        break;
      case "bug":
        typeColor = Color(0xFF2CDAB1);
        break;
      case "fire":
        typeColor = Color(0xFFF7786B);
        break;
      case "water":
        typeColor = Color(0xFF58ABF6);
        break;
      case "fighting":
        typeColor = Color(0xFF58ABF6);
        break;
      case "normal":
        typeColor = Color(0xFF58ABF6);
        break;
      case "electric":
        typeColor = Color(0xFFFFCE4B);
        break;
      case "psychic":
        typeColor = Color(0xFFFFCE4B);
        break;
      case "poison":
        typeColor = Color(0xFF9F5BBA);
        break;
      case "ghost":
        typeColor = Color(0xFF9F5BBA);
        break;
      case "ground":
        typeColor = Color(0xFFCA8179);
        break;
      case "rock":
        typeColor = Color(0xFFCA8179);
        break;
      case "dark":
        typeColor = Color(0xFF303943);
        break;
    }
    return typeColor;
  }
}

class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat(this.name, this.baseStat);

  PokemonStat.fromJson(Map json)
      : this.name = json['stat']['name'],
        this.baseStat = json['base_stat'];

  String convertName() {
    String _name = "";
    switch (name.toLowerCase()) {
      case "hp":
        _name = "HP";
        break;
      case "attack":
        _name = "Atk";
        break;
      case "defense":
        _name = "Def";
        break;
      case "special-attack":
        _name = "Sp. Atk";
        break;
      case "special-defense":
        _name = "Sp. Def";
        break;
      case "speed":
        _name = "Speed";
        break;
      default:
        _name = "";
        break;
    }
    return _name;
  }
}
