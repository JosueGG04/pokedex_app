import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/entities/pokemon_evolution_entity.dart';
import 'package:pokedex_app/core/entities/pokemon_stats_entity.dart';
import 'package:pokedex_app/src/views/Details/widgets/pokemon_evolution_widget.dart';
import 'package:pokedex_app/src/views/Details/widgets/pokemon_info_tab.dart';
import 'package:pokedex_app/src/views/Details/widgets/pokemon_moves_tab.dart';
import 'package:pokedex_app/src/views/Details/widgets/pokemon_stats_tab.dart';
import '../../../../core/entities/pokemon_info_entity.dart';
import '../../../../core/entities/pokemon_list_entity.dart';
import '../../../../core/entities/pokemon_moves_entity.dart';
import '../../../../core/repositories/pokemon_details_repository.dart';
import '../../../../core/utils/type_colors.dart';

class PokemonInfoScreen extends StatefulWidget {
  final PokemonListEntity pokemon;
  final PokemonDetailsRepository repository;

  const PokemonInfoScreen(
      {super.key, required this.pokemon, required this.repository});

  @override
  State<PokemonInfoScreen> createState() => _PokemonInfoScreenState();
}

class _PokemonInfoScreenState extends State<PokemonInfoScreen>
    with SingleTickerProviderStateMixin {
  late PokemonInfoEntity _pokemonInfo;
  late TabController _tabController;
  late PokemonStatsEntity _pokemonStats;
  late List<PokemonMovesEntity> _pokemonMoves;
  late List<PokemonEvolutionEntity> _pokemonEvolutionList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pokemonInfo = PokemonInfoEntity(
        id: widget.pokemon.pokedexNumber,
        genus: '',
        description: '',
        height: 0,
        weight: 0,
        name: '',
        abilities: []);
    _pokemonStats = PokemonStatsEntity(
        hp: 0,
        attack: 0,
        defense: 0,
        specialAttack: 0,
        specialDefense: 0,
        speed: 0);
    _pokemonMoves = [];
    _pokemonEvolutionList = [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchPokemonInfo() async {
    try {
      final pokemonInfo =
          await widget.repository.getPokemonInfo(context, widget.pokemon.id);
      setState(() {
        _pokemonInfo = pokemonInfo;
      });
    } catch (e) {
      print('Error al cargar información del Pokémon: $e');
    }
  }

  Future<void> _fetchPokemonStats() async {
    try {
      final pokemonStats =
          await widget.repository.getPokemonStats(context, widget.pokemon.id);
      setState(() {
        _pokemonStats = pokemonStats;
      });
    } catch (e) {
      print('Error al cargar estadísticas del Pokémon: $e');
    }
  }

  Future<void> _fetchPokemonMoves() async {
    try {
      final pokemonMoves =
          await widget.repository.getPokemonMoves(context, widget.pokemon.id);
      setState(() {
        _pokemonMoves = pokemonMoves;
      });
    } catch (e) {
      print('Error al cargar movimientos del Pokémon: $e');
    }
  }

  Future<void> _fetchPokemonEvolution() async {
    try {
      final pokemonEvolutionList = await widget.repository.getPokemonEvolution(
          context, widget.pokemon.id);
      setState(() {
        _pokemonEvolutionList = pokemonEvolutionList;
      });
    } catch (e) {
      print('Error al cargar evolución del Pokémon: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPokemonInfo();
    _fetchPokemonStats();
    _fetchPokemonMoves();
    _fetchPokemonEvolution();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightTypeColors[widget.pokemon.type[0]],
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -30,
            left: -50,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/icons/pokeball.png',
                height: height * 0.5,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.65,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: typeColors[widget.pokemon.type[0]],
                      tabs: const [
                        Tab(text: 'Info'),
                        Tab(text: 'Stats'),
                        Tab(text: 'Moves'),
                        Tab(text: 'Evolution'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          PokemonInfoTab(
                              pokemonInfo: _pokemonInfo,
                              pokemon: widget.pokemon),
                          PokemonStatsTab(
                              pokemonStats: _pokemonStats,
                              pokemon: widget.pokemon),
                          PokemonMovesTab(
                              pokemonMoves: _pokemonMoves,
                              pokemon: widget.pokemon),
                          PokemonEvolutionWidget(evolutions: _pokemonEvolutionList),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () => Navigator.pop(context)),
          ),
          Positioned(
            top: (height * 0.07),
            left: (width / 2) - 70,
            child: widget.pokemon.spriteUrl != null
                ? Hero(
                    tag: widget.pokemon.id,
                    child: Image.network(
                        widget.pokemon.spriteUrl,
                        height: height * 0.30,
                        fit: BoxFit.fitHeight,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                )
                : const Icon(Icons.image_not_supported),
          ),
          Positioned(
            top: 80,
            left: 20,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "#${widget.pokemon.id.toString().padLeft(3, '0')}",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                widget.pokemon.name,
                style: const TextStyle(
                    fontFamily: 'Google',
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: widget.pokemon.type
                    .map((type) => Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 5, 0),
                          child: SvgPicture.asset(
                            'assets/icons/$type.svg',
                            height: 40,
                            width: 40,
                          ),
                        ))
                    .toList(),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
