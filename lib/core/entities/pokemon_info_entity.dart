
class PokemonInfoEntity {
  int id;
  String flavorText;
  String description;
  double height;
  double weight;
  List<dynamic> ability;
  List<dynamic> generation;
  String biology;
  String etimology;

  PokemonInfoEntity({
    required this.id,
    required this.flavorText,
    required this.description,
    required this.height,
    required this.weight,
    required this.ability,
    required this.generation,
    required this.biology,
    required this.etimology,
  });

}