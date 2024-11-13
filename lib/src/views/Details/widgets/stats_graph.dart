import 'package:flutter/material.dart';
import 'package:pokedex_app/core/entities/pokemon_stats_entity.dart';

class StatsGraph extends StatelessWidget {
  final PokemonStatsEntity stats;
  final Color typeColor;
  final bool min;
  final bool max;

  const StatsGraph({super.key, required this.stats, required this.typeColor, this.min = false, this.max = false});

  int statValue(int value, {bool hp = false}) {
    if (hp){
      if (min) {
        return stats.calculateMinHp(value);
      } else if (max) {
        return stats.calculateMaxHp(value);
      } else {
        return value;
      }
    }
    if (min) {
      return stats.calculateMinStat(value);
    } else if (max) {
      return stats.calculateMaxStat(value);
    } else {
      return value;
    }
  }

  int widthFactorCalculation() {
    int maxStat = stats.maxStat;
    if (min || max) {
      return maxStat;
    } else {
      return 255;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            _buildStatBar('HP', statValue(stats.hp, hp: true), typeColor, true),
            _buildStatBar('Attack', statValue(stats.attack), typeColor, false),
            _buildStatBar('Defense', statValue(stats.defense), typeColor, false),
            _buildStatBar('Sp. Attack', statValue(stats.specialAttack), typeColor, false),
            _buildStatBar('Sp. Defense', statValue(stats.specialDefense), typeColor, false),
            _buildStatBar('Speed', statValue(stats.speed), typeColor, false),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, int value, Color color, bool hp) {
    int maximumStat = widthFactorCalculation();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(fontSize: 10)),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: min ? value / maximumStat : max ? value / maximumStat : value / 255,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(value.toString(), style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}