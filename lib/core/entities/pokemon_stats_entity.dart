
class PokemonStatsEntity {
  int hp;
  int attack;
  int defense;
  int specialAttack;
  int specialDefense;
  int speed;

  PokemonStatsEntity({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  factory PokemonStatsEntity.fromMap(Map<String, dynamic> map) {
    return PokemonStatsEntity(
      hp: map['hp'],
      attack: map['attack'],
      defense: map['defense'],
      specialAttack: map['specialAttack'],
      specialDefense: map['specialDefense'],
      speed: map['speed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hp': hp,
      'attack': attack,
      'defense': defense,
      'specialAttack': specialAttack,
      'specialDefense': specialDefense,
      'speed': speed,
    };
  }
}