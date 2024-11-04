import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
class PokemonListRepository {

  String getPokemonsQuery = """
  query getPokemons(\$limit: Int!, \$offset: Int = 0) {
    pokemon_v2_pokemon(offset: \$offset, limit: \$limit) {
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

  Future<List<PokemonListEntity>> getPokemons(BuildContext context, int limit, int offset) async {
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(getPokemonsQuery),
      variables: {'limit': limit, 'offset': offset},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final pokemons = result.data!['pokemon_v2_pokemon'] as List;

    return pokemons.map((pokemon) => PokemonListEntity(
      id: pokemon['id'],
      name: pokemon['name'],
      spriteUrl: pokemon['pokemon_v2_pokemonsprites'][0]['sprites'],
      type: (pokemon['pokemon_v2_pokemontypes'] as List).map((type) => type['pokemon_v2_type']['name']).toList(),
    )).toList();
  }
}