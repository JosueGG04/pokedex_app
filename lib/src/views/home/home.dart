import 'package:flutter/material.dart';
import 'package:pokedex_app/core/repositories/pokemon_list_repository.dart';
import 'package:pokedex_app/src/views/home/widgets/pokemon_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('PokeDex',
                style: GoogleFonts.concertOne(
                  textStyle: const TextStyle(
                    fontSize: 35,
                  ),
                )),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
            ),
          ],
        ),
        body: <Widget>[
          PokemonListScreen(
              key: const Key("Normal"), repository: PokemonListRepository()),
          PokemonListScreen(
              key: const Key("Favorites"),
              repository: PokemonListRepository(),
              isFavorites: true),
        ][currentPageIndex],
      ),
    );
  }
}
