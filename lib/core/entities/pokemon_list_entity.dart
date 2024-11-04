
class PokemonListEntity {
  int id;
  String name;
  String spriteUrl;
  List<dynamic> type;

  PokemonListEntity({
    required this.id,
    required this.name,
    required this.spriteUrl,
    required this.type,
  });
}