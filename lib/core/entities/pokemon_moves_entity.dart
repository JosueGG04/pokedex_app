
class PokemonMovesEntity {
  String name;
  double? accuracy;
  int pp;
  int? power;
  int level;
  String type;
  String damageClass;
  String learningMethod;
  int learningMethodId;

  PokemonMovesEntity({
    required this.name,
    required this.accuracy,
    required this.pp,
    required this.power,
    required this.level,
    required this.type,
    required this.damageClass,
    required this.learningMethod,
    required this.learningMethodId,
  });

  static learningMethodCategory(int id) {
    if (id == 1) {
      return 'Level up';
    } else if (id == 4) {
      return 'Machine';
    } else{
      return 'Others';
    }
  }

  static Map<String, List<PokemonMovesEntity>> groupByMethod(
      List<PokemonMovesEntity> moves) {
    Map<String, List<PokemonMovesEntity>> groupedMoves = {
      'Level up': [],
      'Machine': [],
      'Others': [],
    };

    for (var move in moves) {
      groupedMoves[learningMethodCategory(move.learningMethodId)]!.add(move);
    }

    return groupedMoves;
  }

  static int compareByLevel(PokemonMovesEntity a, PokemonMovesEntity b) {
    return a.level.compareTo(b.level);
  }
}