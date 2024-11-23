
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import 'package:pokedex_app/src/views/home/widgets/pokemon_list_tile.dart';

class PokemonEvolutionEntity {
  final int id;
  final int? evolvesFromId;
  final PokemonListEntity pokemonListTile;

  PokemonEvolutionEntity(
    {required this.id, 
    required this.evolvesFromId, 
    required this.pokemonListTile}
  );
}