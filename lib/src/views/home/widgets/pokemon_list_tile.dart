import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import 'package:pokedex_app/core/utils/LocalStorage.dart';
import 'package:pokedex_app/core/utils/type_colors.dart';
import '../../../../core/repositories/pokemon_details_repository.dart';
import '../../Details/widgets/pokemon_info_screen.dart';

const double pokemonImgSize = 100, typeIconSize = 22;

class PokemonListTile extends StatefulWidget {
  final PokemonListEntity pokemon;
  final int index;
  final List<PokemonListEntity> pokemonList;
  

  const PokemonListTile({super.key, required this.pokemon, required this.index, required this.pokemonList});

  @override
  _PokemonListTileState createState() => _PokemonListTileState();
}

class _PokemonListTileState extends State<PokemonListTile> {
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    if (LocalStorage.prefs.containsKey('favorites')) {
      isFavorite = LocalStorage.prefs.getStringList('favorites')!.contains("${widget.pokemon.id}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PokemonInfoScreen(pokemonList: widget.pokemonList, repository: PokemonDetailsRepository(), initialIndex: widget.index),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), 
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: widget.pokemon.type.length > 1 ? [lightTypeColors[widget.pokemon.type[0]]!, lightTypeColors[widget.pokemon.type[1]]!] : [lightTypeColors[widget.pokemon.type[0]]!, typeColors[widget.pokemon.type[0]]!],
            ),
          ),
          height: 100,
          child: Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: Row(
              children: [
                Hero(
                  tag: widget.pokemon.id,
                  child: Image.network(widget.pokemon.spriteUrl, fit: BoxFit.fitHeight, width: pokemonImgSize, height: pokemonImgSize)
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        widget.pokemon.name, 
                        style: const TextStyle(fontFamily: 'Google', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Row(
                      children: widget.pokemon.type.map((type) => 
                        Padding(
                          padding: const EdgeInsets.only(right: 5, bottom: 20),
                          child: SvgPicture.asset(
                            'assets/icons/$type.svg',
                            height: typeIconSize,
                            width: typeIconSize,
                          ),
                        )
                      ).toList(),
                    )
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            isSelected: isFavorite,
                            icon: const Icon(Icons.star_outline), 
                            selectedIcon: const Icon(Icons.star, color: Colors.yellow), 
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                                if (isFavorite) {
                                  LocalStorage.prefs.setStringList('favorites', [...LocalStorage.prefs.getStringList('favorites')!, "${widget.pokemon.id}"]);
                                } else {
                                  LocalStorage.prefs.setStringList('favorites', LocalStorage.prefs.getStringList('favorites')!.where((element) => element != "${widget.pokemon.id}").toList());
                                }
                              });
                            },
                          ),
                          Text("#${widget.pokemon.pokedexNumber.toString().padLeft(3, '0')}", style: const TextStyle(color: Colors.white, fontFamily: 'Google', fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}