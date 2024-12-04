import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:pokedex_app/core/entities/pokemon_evolution_entity.dart';
import 'package:pokedex_app/core/repositories/pokemon_details_repository.dart';
import 'package:pokedex_app/core/utils/type_colors.dart';
import 'package:pokedex_app/src/views/Details/widgets/pokemon_info_screen.dart';
import 'package:pokedex_app/src/views/home/widgets/pokemon_list_tile.dart';

class PokemonEvolutionWidget extends StatefulWidget {
  final List<PokemonEvolutionEntity> evolutions;

  const PokemonEvolutionWidget({Key? key, required this.evolutions})
      : super(key: key);

  @override
  _PokemonEvolutionWidgetState createState() => _PokemonEvolutionWidgetState();

}

class _PokemonEvolutionWidgetState extends State<PokemonEvolutionWidget> {
  Map<int, PokemonEvolutionEntity> evolutions = {};
  Map<int, Node> nodes = {};

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: InteractiveViewer(
              alignment: Alignment.center,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.01,
              maxScale: 2.6,
              child: GraphView(
                graph: graph,
                algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                paint: Paint()
                  ..color = Colors.black
                  ..strokeWidth = 5
                  ..style = PaintingStyle.stroke,
                builder: (Node node) {
                  // I can decide what widget should be shown here based on the id
                  var a = node.key?.value as int;
                  return pokemon(a);
                },
              )),
        ),
      ],
    ));
  }

  Random r = Random();

  Widget pokemon(int a) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: 200,
          child: EvolutionTile(evolution: evolutions[a]!)),
      ],
    );
  }

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    for (var evolution in widget.evolutions) {
      evolutions[evolution.id] = evolution;
      final node = Node.Id(evolution.id);
      nodes[evolution.id] = node;
      graph.addNode(node);
    }

    for (var evolution in widget.evolutions) {
      if (evolution.evolvesFromId != null) {
        graph.addEdge(nodes[evolution.evolvesFromId]!, nodes[evolution.id]!, paint: Paint()..color = Colors.black);
      }
    }

    builder
      ..siblingSeparation = (10)
      ..levelSeparation = (15)
      ..subtreeSeparation = (15)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT);
  }

}

class EvolutionTile extends StatelessWidget {
  final PokemonEvolutionEntity evolution;

  const EvolutionTile({Key? key, required this.evolution}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pokemonImgSize = MediaQuery.of(context).size.width * 0.15;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PokemonDetailsView(
              pokemon: evolution.pokemonListTile,
              repository: PokemonDetailsRepository(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: evolution.pokemonListTile.type.length > 1
                  ? [
                      lightTypeColors[evolution.pokemonListTile.type[0]]!,
                      lightTypeColors[evolution.pokemonListTile.type[1]]!
                    ]
                  : [
                      lightTypeColors[evolution.pokemonListTile.type[0]]!,
                      typeColors[evolution.pokemonListTile.type[0]]!
                    ],
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.10,
          child: Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: Column(
              children: [
                Image.network(evolution.pokemonListTile.spriteUrl,
                    fit: BoxFit.fitHeight, width: pokemonImgSize, height: pokemonImgSize),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        evolution.pokemonListTile.name,
                        style: const TextStyle(
                            fontFamily: 'Google',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}