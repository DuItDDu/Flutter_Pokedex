import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/app/pokedex/detail/pokedex_detail.dart';
import 'package:pokedex/bloc/pokemon_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/app/ui/widgets/EmptyWidget.dart';
import 'package:pokedex/model/PokemonGeneration.dart';

class PokedexPage extends StatefulWidget {
  @override
  _PokedexPageState createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> with WidgetsBindingObserver {
  final PokemonBloc _bloc = PokemonBloc(PokemonApi());
  final _pokemonListController = ScrollController();

  AudioCache _audioPlayer = AudioCache();
  AudioPlayer _player = AudioPlayer();
  WidgetsBinding _binding = WidgetsBinding.instance;

  _PokedexPageState() {
    _bloc.requestPokemonList();
  }

  @override
  void initState() {
    super.initState();
    AudioPlayer.logEnabled = false;
    _playAudio();
    _binding.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _stopAudio();
    _binding.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Pokedex'),
        ),
        body: _createPokedexBody(),
      drawer: _createPokedexDrawer(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        _playAudio();
        break;
      case AppLifecycleState.inactive:
        _stopAudio();
        break;
      default:
        break;
    }
  }

  void _playAudio() async {
    _player = await _audioPlayer.loop("pokedex.mp3");
  }

  void _stopAudio() {
    _player?.stop();
  }

  Widget _createPokedexDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _createPokedexDrawerHeader(),
          _createPokedexDrawerGenerationList()
        ],
      ),
    );
  }

  Widget _createPokedexDrawerHeader() {
    return DrawerHeader(
        child: Text(
          "포켓몬 도감",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24.0),
        ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0)
        )
      ),
    );
  }
  Widget _createPokedexDrawerGenerationList() {
    return StreamBuilder(
        stream: _bloc.generation,
        builder: (context, AsyncSnapshot<PokemonGeneration> snapshot) {
          return Column(
            children: _bloc.generations.map((e) {
              bool isSelected = snapshot.hasData ? snapshot.data.number == e.number : false;
              return _createPokedexDrawerGenerationCard(e, isSelected);
            }).toList(),
          );
        }
    );
  }

  Widget _createPokedexDrawerGenerationCard(PokemonGeneration generation, bool isSelected) {
    return Card(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        color: generation.color,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: InkWell(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${generation.number}세대 ${generation.name}도감",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 18.0),
                ),

                Builder(builder: (context) {
                  if (isSelected) {
                    return Icon(Icons.check, color: Colors.white);
                  } else {
                    return EmptyWidget();
                  }
                }),
              ],
            )
          ),
          onTap: () {
            _bloc.onGenerationClick(generation);
            Navigator.of(context).pop();

            _pokemonListController.animateTo(_pokemonListController.position.minScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
          },
        )
    );
  }

  Widget _createPokedexBody() {
    return Stack(
      children: [
        Column(
          children: [
            _createPokemonGenerationTitle(),
            Expanded(child: _createPokemonListContainer())
          ],
        ),
        _createLoadingBuilder()
      ],
    );
  }

  Widget _createPokemonGenerationTitle() {
    return StreamBuilder(
      stream: _bloc.generation,
      builder: (context, AsyncSnapshot<PokemonGeneration> snapshot) {
        if (snapshot.hasData) {
          PokemonGeneration generation = snapshot.data;
          return Container(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                  margin: EdgeInsets.fromLTRB(4.0, 16.0, 8.0, 16.0),
                  color: generation.color,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Text(
                        "${generation.number}세대 ${generation.name}도감",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24.0
                        ),
                      ),
                    )
                ),
                Text(
                  "#${generation.start.toString().padLeft(3, '0')} ~ #${generation.end.toString().padLeft(3, '0')}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: generation.color,
                      fontSize: 20.0),
                )
              ],
            )
          );
        } else {
          return EmptyWidget();
        }
      },
    );
  }

  Widget _createPokemonListContainer() {
    return Container(
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
    );
  }

  Widget _createLoadingBuilder() {
    return StreamBuilder(
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
        });
  }

  Widget _createPokemonList(List<Pokemon> pokemonList) {
    if (pokemonList != null) {
      return GridView.builder(
        controller: _pokemonListController,
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
        child: InkWell(
          child: Container(
            color: pokemon.getPrimaryColor(),
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
          ),
          onTap: () {
            _stopAudio();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PokedexDetailPage(pokemon: pokemon)
                )
            ).then((value) => {
              _playAudio()
            });
          },
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
              color: Colors.white70,
              fontSize: 16.0),
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
            FadeInImage(
                width: 100,
                height: 100,
                placeholder: AssetImage('assets/pokemon_placeholder.png'),
                image: NetworkImage(pokemon.imageUrl))
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

