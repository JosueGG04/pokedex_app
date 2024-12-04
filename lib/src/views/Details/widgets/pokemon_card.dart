import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/entities/pokemon_info_entity.dart';
import '../../../../core/entities/pokemon_list_entity.dart';
import '../../../../core/repositories/pokemon_details_repository.dart';
import '../../../../core/utils/type_colors.dart';

class PokemonCard extends StatefulWidget {
  final PokemonListEntity pokemon;
  final PokemonInfoEntity pokemonInfo;

  const PokemonCard(
      {super.key, required this.pokemon, required this.pokemonInfo});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var height = 500.0;
    var width = 400.0;
    return Container(
      color: lightTypeColors[widget.pokemon.type[0]],
      child: Stack(
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
            top: height * 0.50,
            child: Container(
              width: width,
              height: height * 0.65,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: lightTypeColors[widget.pokemon.type[0]],
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
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
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 4, 5, 0),
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
                                        Icon(Icons.straighten,
                                            color: Colors.grey[700], size: 24),
                                        const Text("Height",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "${(widget.pokemonInfo.height / 10).toStringAsFixed(1)} m"),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      children: [
                                        Icon(Icons.fitness_center,
                                            color: Colors.grey[700], size: 24),
                                        const Text("Weight",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "${(widget.pokemonInfo.weight / 10).toStringAsFixed(1)} kg"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: (height * 0.07),
            left: (width / 2) - 70,
            child: widget.pokemon.spriteUrl != null
                ? Hero(
              tag: widget.pokemon.id,
              child: Image.network(
                widget.pokemon.spriteUrl,
                height: height * 0.40,
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