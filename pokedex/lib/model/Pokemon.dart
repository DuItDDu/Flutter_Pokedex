class Pokemon {
  final String name, url;

  String _imageUrl;

  Pokemon(this.name, this.url);

  Pokemon.fromJson(Map json): name = json['name'], url = json['url'];

  void setImageUrl(int id) {
    this._imageUrl = "https://pokeres.bastionbot.org/images/pokemon/$id.png";
  }

  String getImageUrl() {
    return this._imageUrl;
  }
}