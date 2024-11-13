
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

  int get total => hp + attack + defense + specialAttack + specialDefense + speed;

  int calculateMaxHp(int baseHp, {int level = 100, int iv = 31, int ev = 252}) {
    return ((2 * baseHp + iv + (ev / 4)) * level ~/ 100) + level + 10;
  }

  int calculateMaxStat(int baseStat, {int level = 100, int iv = 31, int ev = 252}) {
    return ((((2 * baseStat + iv + (ev / 4)) * level ~/ 100) + 5)* 1.1).toInt();
  }

  int calculateMinHp(int baseHp, {int level = 100, int iv = 0, int ev = 0}) {
    return ((2 * baseHp) * level ~/ 100) + level + 10;
  }

  int calculateMinStat(int baseStat, {int level = 100, int iv = 0, int ev = 0}) {
    return ((((2 * baseStat) * level ~/ 100) + 5) * 0.9).toInt();
  }

  int get maxStat {
    return [
      calculateMaxHp(hp),
      calculateMaxStat(attack),
      calculateMaxStat(defense),
      calculateMaxStat(specialAttack),
      calculateMaxStat(specialDefense),
      calculateMaxStat(speed)
    ].reduce((value, element) => value > element ? value : element);
  }
}