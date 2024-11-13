
class PokemonListEntity {
  int id;
  int pokedexNumber;
  String name;
  String spriteUrl;
  List<dynamic> type;

  PokemonListEntity({
    required this.id,
    required this.pokedexNumber,
    required this.name,
    required this.spriteUrl,
    required this.type,
  });
}