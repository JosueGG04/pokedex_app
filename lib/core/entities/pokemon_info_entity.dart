
import 'package:pokedex_app/core/entities/pokemon_abilities_entity.dart';

class PokemonInfoEntity {
  int id;
  String name;
  String genus;
  String description;
  double height;
  double weight;
  List<Ability> abilities;

  PokemonInfoEntity({
    required this.id,
    required this.name,
    required this.genus,
    required this.description,
    required this.height,
    required this.weight,
    required this.abilities,
  });

}