import 'package:flutter/material.dart';
import 'package:pokedex_app/core/repositories/pokemon_list_repository.dart';
import 'package:pokedex_app/src/views/home/widgets/pokemon_list_screen.dart';

class Home extends StatefulWidget {
  Home({super.key});
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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