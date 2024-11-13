import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';

import '../../../../core/repositories/pokemon_details_repository.dart';
import '../../Details/widgets/pokemon_info_screen.dart';

class PokemonListTile extends StatelessWidget {
  final PokemonListEntity pokemon;

  const PokemonListTile({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: pokemon.spriteUrl != null
          ? Image.network(
        pokemon.spriteUrl,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      )
          : Icon(Icons.image_not_supported),
      title: Text(pokemon.name),
      subtitle: Row(
        children: pokemon.type?.map((type) =>
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 5, 0),
              child: SvgPicture.asset(
                'assets/icons/$type.svg',
                height: 20,
                width: 20,
              ),
            )
        ).toList() ?? [],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PokemonInfoScreen(pokemon: pokemon, repository: PokemonDetailsRepository()),
          ),
        );
      },
    );
  }
}