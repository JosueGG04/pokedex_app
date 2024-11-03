import 'package:flutter/material.dart';
import 'package:pokedex_app/core/routes/routes.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeDex',
      routes: routes,
      initialRoute: '/',
    );
  }
}
