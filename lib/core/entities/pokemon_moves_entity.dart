
class PokemonMovesEntity {
  String name;
  double? accuracy;
  int pp;
  int? power;
  int level;
  List<dynamic> type;

  PokemonMovesEntity({
    required this.name,
    required this.accuracy,
    required this.pp,
    required this.power,
    required this.level,
    required this.type,
  });
}