import 'package:flutter/material.dart';
import 'package:pokedex_app/core/entities/pokemon_stats_entity.dart';
import 'package:pokedex_app/src/views/Details/widgets/stats_graph.dart';

import '../../../../core/entities/pokemon_list_entity.dart';
import '../../../../core/utils/type_colors.dart';

class PokemonStatsTab extends StatefulWidget {
  final PokemonStatsEntity pokemonStats;
  final PokemonListEntity pokemon;

  const PokemonStatsTab({super.key, required this.pokemonStats, required this.pokemon});

  @override
  State<PokemonStatsTab> createState() => _PokemonStatsTabState();
}

class _PokemonStatsTabState extends State<PokemonStatsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: width / 0.5,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          TabBar(
                            labelColor: typeColors[widget.pokemon.type[0]]!,
                            indicatorColor: typeColors[widget.pokemon.type[0]]!,
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Base'),
                              Tab(text: 'Min'),
                              Tab(text: 'Max'),
                            ],
                          ),
                          SizedBox(
                            height: 180,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                StatsGraph(
                                  stats: widget.pokemonStats,
                                  typeColor: typeColors[widget.pokemon.type[0]]!,
                                ),
                                StatsGraph(
                                  stats: widget.pokemonStats,
                                  typeColor: typeColors[widget.pokemon.type[0]]!,
                                  min: true,
                                ),
                                StatsGraph(
                                  stats: widget.pokemonStats,
                                  typeColor: typeColors[widget.pokemon.type[0]]!,
                                  max: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: typeColors[widget.pokemon.type[0]]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Base Stats",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: typeColors[widget.pokemon.type[0]],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
