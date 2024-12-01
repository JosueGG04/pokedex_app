import 'package:flutter/material.dart';
import 'package:pokedex_app/core/repositories/pokemon_list_repository.dart';  
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import 'package:pokedex_app/src/views/home/widgets/filters_modal.dart';
import 'package:pokedex_app/src/views/home/widgets/pokemon_list_tile.dart'; 

class PokemonListScreen extends StatefulWidget {
  final PokemonListRepository repository;
  final bool isFavorites;

  const PokemonListScreen({super.key, required this.repository, this.isFavorites = false});

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
  final List<String> _typeFilters = [];
  String _selectedGen = '';
  String _selectedAbility = '';


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
      final newPokemons = await widget.repository.getPokemons(context, _limit, _offset, searchTerm: _searchTerm, types: _typeFilters, generation: _selectedGen, ability: _selectedAbility, favorites: widget.isFavorites);
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
  void _refreshList() {
    setState(() {
      _clearList();
      _fetchPokemons();
    });
    controller.jumpTo(0);
  }

  void _clearList() {
    setState(() {
      _offset = 0;
      _pokemonList.clear();
    });
  }

  void _onGenSelected(String gen) {
    setState(() {
      _selectedGen = gen;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text;
    });
    _refreshList();
  }

  void _onAbilitySelected(String ability) {
    setState(() {
      _selectedAbility = ability;
    });
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FiltersModal(
                      typeFilters: _typeFilters, 
                      selectedGen: _selectedGen, 
                      refreshList: _refreshList, 
                      onGenSelected: _onGenSelected, 
                      onAbilitySelected: _onAbilitySelected, 
                      selectedAbility: _selectedAbility,
                      repository: widget.repository,
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
              },
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
