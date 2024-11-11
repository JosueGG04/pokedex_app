import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/src/views/Details/widgets/pokemon_info_tab.dart';
import '../../../../core/entities/pokemon_info_entity.dart';
import '../../../../core/entities/pokemon_list_entity.dart';
import '../../../../core/repositories/pokemon_details_repository.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pokemonInfo = PokemonInfoEntity(id: widget.pokemon.id, genus: '', description: '', height: 0, weight: 0, name: '', ability: []);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPokemonInfo();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        alignment: Alignment.center,
        children: [
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
                      labelStyle: const TextStyle(fontSize: 18),
                      tabs: const [
                        Tab(text: 'Info'),
                        Tab(text: 'Stats'),
                        Tab(text: 'Moves'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          PokemonInfoTab(pokemonInfo: _pokemonInfo, pokemon: widget.pokemon),
                          const Center(child: Text('Stats of the Pokémon')),
                          const Center(child: Text('Moves of the Pokémon')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: (height * 0.07),
            left: (width / 2) - 100,
            child: widget.pokemon.spriteUrl != null
                ? Image.network(
                    widget.pokemon.spriteUrl,
                    height: 275,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  )
                : const Icon(Icons.image_not_supported),
          )
        ],
      ),
    );
  }
}
