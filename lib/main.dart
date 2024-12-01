import 'package:flutter/material.dart';
import 'package:pokedex_app/core/routes/route_generator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_app/core/utils/LocalStorage.dart';

void main() async{
  await initHiveForFlutter();
  await LocalStorage.init();
  LocalStorage.favoritesInit();
  final HttpLink httpLink = HttpLink('https://beta.pokeapi.co/graphql/v1beta'); 

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(store: HiveStore()),
    link: httpLink,
  );

  runApp(MainApp(client: client));
}

class MainApp extends StatelessWidget {
  final GraphQLClient client;

  const MainApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(client), // Provee el cliente GraphQL
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PokeDex',
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
