import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';

class PokemonListTile extends StatelessWidget {
  final PokemonListEntity pokemon;

  const PokemonListTile({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: pokemon.spriteUrl != null
          ? Image.network(pokemon.spriteUrl)
          : Icon(Icons.image_not_supported),
      title: Text(pokemon.name),
      subtitle: Row( 
        children: pokemon.type.map((type) => 
          Padding(
            padding: const EdgeInsets.fromLTRB(0,4,5,0), // Ajusta el valor del padding según sea necesario
            child: SvgPicture.asset(
              'assets/icons/$type.svg',
              height: 20,
              width: 20,
              color: null,
            ),
          )
        ).toList(),
      ),
    );
  }
}