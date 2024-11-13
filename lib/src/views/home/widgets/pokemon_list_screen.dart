import 'package:flutter/material.dart';
import 'package:pokedex_app/core/repositories/pokemon_list_repository.dart';  
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import 'package:pokedex_app/src/views/home/widgets/pokemon_list_tile.dart'; 

class PokemonListScreen extends StatefulWidget {
  final PokemonListRepository repository;

  const PokemonListScreen({super.key, required this.repository});

  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final List<PokemonListEntity> _pokemonList = [];
  bool _isLoadingMore = false;
  bool _isFirstLoad = true; 
  int _offset = 0;
  final int _limit = 20;
  String _searchTerm = '';
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset && !_isLoadingMore) {
        _fetchPokemons();
      }
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _fetchPokemons();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPokemons() async {
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final newPokemons = await widget.repository.getPokemons(context, _limit, _offset, _searchTerm);
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

  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text;
      _offset = 0;
      _pokemonList.clear();
    });
    _fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Pokémon',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {},
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            controller: controller,
            itemCount: _pokemonList.length + 1,
            itemBuilder: (context, index) {
              if (index == _pokemonList.length) {
                return _isLoadingMore && _pokemonList.length != _limit+_offset
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              final pokemon = _pokemonList[index];
              return PokemonListTile(pokemon: pokemon);
            },
          ),
        ),
      ],
    );
  }
}
