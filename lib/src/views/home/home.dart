import 'package:flutter/material.dart';
import 'package:pokedex_app/core/repositories/pokemon_list_repository.dart';
import 'package:pokedex_app/src/views/home/widgets/pokemon_list_screen.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PokeDex'),
        ),
        body: PokemonListScreen(repository: PokemonListRepository()),
      ),
    );
  }
}
