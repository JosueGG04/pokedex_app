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
  final PokemonDetailsRepository repository;
  final ScreenshotController screenshotController;

  const PokemonCard(
      {super.key, required this.pokemon, required this.repository, required this.screenshotController});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  late PokemonInfoEntity _pokemonInfo;

  @override
  void initState() {
    super.initState();
    _pokemonInfo = PokemonInfoEntity(
        id: widget.pokemon.pokedexNumber,
        genus: '',
        description: '',
        height: 0,
        weight: 0,
        name: '',
        abilities: []);
  }

  @override
  void dispose() {
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
    return Screenshot(
        controller: widget.screenshotController,
        child: Scaffold(
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
                                  _pokemonInfo.genus,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _pokemonInfo.description,
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
                                        Icon(Icons.straighten,
                                            color: Colors.grey[700], size: 24),
                                        const Text("Height",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "${(_pokemonInfo.height / 10).toStringAsFixed(1)} m"),
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
                                            "${(_pokemonInfo.weight / 10).toStringAsFixed(1)} kg"),
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
    ));
  }
}

Future<String> captureAndSaveScreenshot(ScreenshotController screenshotController) async {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/screenshot.png';
  await screenshotController.captureAndSave(directory.path, fileName: 'screenshot.png');
  return imagePath;
}