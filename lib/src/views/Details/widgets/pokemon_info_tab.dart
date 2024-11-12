import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';

import '../../../../core/entities/pokemon_info_entity.dart';

class PokemonInfoTab extends StatefulWidget {
  final PokemonInfoEntity pokemonInfo;
  final PokemonListEntity pokemon;

  const PokemonInfoTab(
      {super.key, required this.pokemonInfo, required this.pokemon});

  @override
  State<PokemonInfoTab> createState() => _PokemonInfoTabState();
}

class _PokemonInfoTabState extends State<PokemonInfoTab> {
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
                            widget.pokemonInfo.genus,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.pokemonInfo.description,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.pokemon.type
                                .map((type) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 5, 0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/$type.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            type,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.straighten,
                                      color: Colors.blue, size: 24),
                                  const Text("Height",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "${(widget.pokemonInfo.height / 100).toStringAsFixed(1)} m"),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  const Icon(Icons.fitness_center,
                                      color: Colors.brown, size: 24),
                                  const Text("Weight",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "${(widget.pokemonInfo.weight / 100).toStringAsFixed(1)} kg"),
                                ],
                              ),
                            ],
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
                          border: Border.all(color: Colors.green[700]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Species",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
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
