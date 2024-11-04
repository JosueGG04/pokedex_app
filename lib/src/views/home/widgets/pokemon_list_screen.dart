import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_app/core/repositories/pokemon_list_repository.dart';  
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart'; 

class PokemonListScreen extends StatefulWidget {
  final PokemonListRepository repository;

  const PokemonListScreen({super.key, required this.repository});

  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<PokemonListEntity> _pokemonList = [];
  bool _isLoadingMore = false;
  bool _isFirstLoad = true; 
  int _offset = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset && !_isLoadingMore) {
        _fetchPokemons();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _fetchPokemons();
    }
  }

  Future<void> _fetchPokemons() async {
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final newPokemons = await widget.repository.getPokemons(context, _limit, _offset);
      setState(() {
        _pokemonList.addAll(newPokemons);
        _offset += _limit;
      });
    } catch (e) {
      print('Error al cargar Pokémon: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: controller,
        itemCount: _pokemonList.length + 1,
        itemBuilder: (context, index) {
          if (index == _pokemonList.length) {
            return _isLoadingMore
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }
          final pokemon = _pokemonList[index];
          return ListTile(
            leading: pokemon.spriteUrl != null
                ? Image.network(pokemon.spriteUrl)
                : Icon(Icons.image_not_supported),
            title: Text(pokemon.name),
            subtitle: Text('Tipo(s): ${pokemon.type.join(', ')}'),
          );
        },
      ),
    );
  }
}
