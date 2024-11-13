import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import 'package:pokedex_app/core/utils/type_colors.dart';
import '../../../../core/repositories/pokemon_details_repository.dart';
import '../../Details/widgets/pokemon_info_screen.dart';

const double pokemonImgSize = 100, typeIconSize = 22;
class PokemonListTile extends StatelessWidget {
  final PokemonListEntity pokemon;

  const PokemonListTile({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PokemonInfoScreen(pokemon: pokemon, repository: PokemonDetailsRepository()),
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
              colors: pokemon.type.length > 1 ? [lightTypeColors[pokemon.type[0]]!, lightTypeColors[pokemon.type[1]]!] : [lightTypeColors[pokemon.type[0]]!, typeColors[pokemon.type[0]]!],
            ),
          ),
          height: 100,
          child: Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: Row(
              children: [
                Hero(
                  tag: pokemon.id,
                  child: Image.network(pokemon.spriteUrl,fit: BoxFit.fitHeight, width: pokemonImgSize, height: pokemonImgSize)
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        pokemon.name, 
                        style: const TextStyle(fontFamily: 'Google', fontSize: 20, fontWeight: FontWeight.bold,),
                      ),
                    ),
                    Row(
                      children: pokemon.type.map((type) => 
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
                      child: Text("#${pokemon.pokedexNumber.toString().padLeft(3, '0')}", style: const TextStyle(color: Colors.black ,fontFamily: 'Google', fontSize: 20, fontWeight: FontWeight.bold)),
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