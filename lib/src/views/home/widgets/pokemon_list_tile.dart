import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';

const double pokemonImgSize = 75, typeIconSize = 20;
class PokemonListTile extends StatelessWidget {
  final PokemonListEntity pokemon;

  const PokemonListTile({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23), 
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Image.network(pokemon.spriteUrl, width: pokemonImgSize, height: pokemonImgSize),
          title: Text(
            pokemon.name, 
            style: const TextStyle(fontFamily: 'Google', fontSize: 20, fontWeight: FontWeight.bold)
          ),
          subtitle: Row(
            children: pokemon.type.map((type) => 
              Padding(
                padding: const EdgeInsets.fromLTRB(0,4,5,0),
                child: SvgPicture.asset(
                  'assets/icons/$type.svg',
                  height: typeIconSize,
                  width: typeIconSize,
                ),
              )
            ).toList(),
          ),
          trailing: Text("#${pokemon.id.toString().padLeft(3, '0')}", style: const TextStyle(fontFamily: 'Google', fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}