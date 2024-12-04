import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/entities/pokemon_list_entity.dart';
import '../../../../core/entities/pokemon_moves_entity.dart';
import '../../../../core/utils/type_colors.dart';

class PokemonMovesTab extends StatefulWidget {
  final List<PokemonMovesEntity> pokemonMoves;
  final PokemonListEntity pokemon;

  const PokemonMovesTab(
      {super.key, required this.pokemonMoves, required this.pokemon});

  @override
  State<PokemonMovesTab> createState() => _PokemonMovesTabState();
}

class _PokemonMovesTabState extends State<PokemonMovesTab> with SingleTickerProviderStateMixin {
  late Map<String, List<PokemonMovesEntity>> groupedMoves;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    groupedMoves = PokemonMovesEntity.groupByMethod(widget.pokemonMoves);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: width / 0.5,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          TabBar(tabs: 
                            groupedMoves.keys.map((key) => Tab(text: key)).toList(),
                            controller: _tabController,
                            indicatorColor: typeColors[widget.pokemon.type[0]],
                            labelColor: typeColors[widget.pokemon.type[0]],
                            unselectedLabelColor: Colors.grey,
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: TabBarView(
                              controller: _tabController,
                              children: 
                              groupedMoves.keys.map((key) {
                                return SingleChildScrollView(
                                  child: PokemonMovesTable(pokemonMoves: groupedMoves[key]!, tableType: key,),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: typeColors[widget.pokemon.type[0]]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Moves list",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: typeColors[widget.pokemon.type[0]],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonMovesTable extends StatelessWidget {
  final List<PokemonMovesEntity> pokemonMoves;
  final String tableType;

  const PokemonMovesTable({Key? key, required this.pokemonMoves, required this.tableType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    pokemonMoves.sort(PokemonMovesEntity.compareByLevel);
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(color: Colors.black),
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (tableType == "Level up")
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Lvl',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            else
              const SizedBox.shrink(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pow',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Acc',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'PP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        for (var move in pokemonMoves)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      move.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: SvgPicture.asset(
                            'assets/icons/${move.type}.svg',
                            height: 15,
                            width: 15,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              if (tableType== "Level up")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    move.level.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              else
                const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  move.power?.toString() ?? ' -',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  move.accuracy?.toString() ?? '  -',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  move.pp.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
      ],
    );
  }
}