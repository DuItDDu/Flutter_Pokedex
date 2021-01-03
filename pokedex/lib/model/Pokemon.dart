import 'dart:ui';

class Pokemon {
  final int id;
  final String name;
  final int height, weight;
  final String imageUrl;
  final List<PokemonType> types;

  Pokemon(this.id, this.name, this.height, this.weight, this.imageUrl,
      this.types);

  Pokemon.fromJson(Map json)
      : this.id = json['id'],
        this.name = json['name'],
        this.height = json['height'],
        this.weight = json['weight'],
        this.imageUrl =
        "https://pokeres.bastionbot.org/images/pokemon/${json['id']}.png",
        this.types = (json['types'] as List).map((e) {
          return PokemonType.fromJson(e);
        }).toList();

  Color getTypeColor() {
    Color typeColor = Color(0xFF58ABF6);
    String type = types != null && types.length > 0 ? types.first.name : "";

    switch (type.toLowerCase()) {
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

class PokemonType {
  final int slot;
  final String name;
  final String typeUrl;

  PokemonType(this.slot, this.name, this.typeUrl);

  PokemonType.fromJson(Map json)
      : this.slot = json['slot'],
        this.name = json['type']['name'],
        this.typeUrl = json['type']['url'];
}
