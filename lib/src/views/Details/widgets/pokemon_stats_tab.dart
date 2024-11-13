import 'package:flutter/material.dart';
import 'package:pokedex_app/core/entities/pokemon_stats_entity.dart';

import '../../../../core/entities/pokemon_list_entity.dart';
import '../../../../core/utils/type_colors.dart';

class PokemonStatsTab extends StatefulWidget {
  final PokemonStatsEntity pokemonStats;
  final PokemonListEntity pokemon;

  const PokemonStatsTab({super.key, required this.pokemonStats, required this.pokemon});

  @override
  State<PokemonStatsTab> createState() => _PokemonStatsTabState();
}

class _PokemonStatsTabState extends State<PokemonStatsTab> {
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
                          const SizedBox(height: 30),
                          Text(
                            "HP: ${widget.pokemonStats.hp}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Attack: ${widget.pokemonStats.attack}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Defense: ${widget.pokemonStats.defense}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Special Attack: ${widget.pokemonStats.specialAttack}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Special Defense: ${widget.pokemonStats.specialDefense}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Speed: ${widget.pokemonStats.speed}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Total: ${widget.pokemonStats.hp + widget.pokemonStats.attack + widget.pokemonStats.defense + widget.pokemonStats.specialAttack + widget.pokemonStats.specialDefense + widget.pokemonStats.speed}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
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
