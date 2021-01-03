import 'package:flutter/material.dart';
import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/bloc/pokemon_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/app/ui/widgets/EmptyWidget.dart';

class PokedexPage extends StatefulWidget {
  @override
  _PokedexPageState createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final PokemonBloc _bloc = PokemonBloc(PokemonApi());

  _PokedexPageState() {
    _bloc.requestPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Pokedex'),
        ),
        body: Stack(
          children: [
            Container(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _bloc.requestPokemonList();
                  }
                  return false;
                },
                child: StreamBuilder(
                    stream: _bloc.pokemonList,
                    builder: (context, AsyncSnapshot<List<Pokemon>> snapshot) {
                      return _createPokemonList(snapshot.data);
                    }),
              ),
            ),
            StreamBuilder(
                stream: _bloc.isLoading,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return Center(
                        child: CircularProgressIndicator(value: null),
                      );
                    } else {
                      return EmptyWidget();
                    }
                  } else {
                    return EmptyWidget();
                  }
                })
          ],
        ));
  }

  Widget _createPokemonList(List<Pokemon> pokemonList) {
    if (pokemonList != null) {
      return GridView.builder(
        shrinkWrap: true,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: pokemon.getTypeColor(),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createPokemonHeaderRow(pokemon),
              _createPokemonTypeRow(pokemon.types),
              _createPokemonImageRow(pokemon)
            ],
          ),
        )
    );
  }

  Widget _createPokemonHeaderRow(Pokemon pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          pokemon.name,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20.0),
        ),
        Text(
          "#${pokemon.id.toString().padLeft(3, "0")}",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black26,
              fontSize: 18.0),
        ),
      ],
    );
  }

  Widget _createPokemonImageRow(Pokemon pokemon) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              'assets/pokeball.svg',
              color: Colors.white54,
              width: 100,
              height: 100,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              pokemon.imageUrl,
              width: 100,
              height: 100,
              alignment: Alignment.bottomLeft,
            ),
          ],
        )
      ],
    );
  }
  
  Widget _createPokemonTypeRow(List<PokemonType> types) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: types.map((e) => _createPokemonTypeCard(e)).toList()
    );
  }

  Widget _createPokemonTypeCard(PokemonType type) {
    return Card(
        margin: EdgeInsets.only(right: 8.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.white30,
        child: Container(
            padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
            child: Text(
              type.name,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 12.0),
            )
        )
    );
  }
}
