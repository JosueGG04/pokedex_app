import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Home extends StatelessWidget {
  Home({super.key});

  String query = """
  query getPokemons(\$limit: Int!) {
    pokemon_v2_pokemon(offset: 0, limit: \$limit) {
      name
      id
      pokemon_v2_pokemonsprites {
        sprites(path: "other.home.front_default")
      }
      pokemon_v2_pokemontypes {
        pokemon_v2_type {
          name
        }
      }
    }
  }
  """;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PokeDex'),
        ),
        body: Query(
          options: QueryOptions(
            document: gql(query),
            variables: {'limit': 20},
          ),
          builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception.toString()}'));
            }

            final pokemons = result.data!['pokemon_v2_pokemon'] as List;

            return ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                print(pokemon['pokemon_v2_pokemontypes'].length);
                final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];

                return ListTile(
                  leading: Image.network(spriteUrl),
                  title: Text('${pokemon['name']}'),
                  subtitle: Text('Type: ${pokemon['pokemon_v2_pokemontypes'][0]['pokemon_v2_type']['name']}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
