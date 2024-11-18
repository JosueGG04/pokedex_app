import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import 'package:pokedex_app/core/utils/filter_utils.dart';

class PokemonListRepository {

  String getPokemonsQuery = """
  query getPokemons(\$limit: Int = 20, \$offset: Int = 0, \$searchTerm: String = "%%", \$types: [String] = "\$") {
    pokemon_v2_pokemon(offset: \$offset, limit: \$limit, where: {pokemon_v2_pokemonspecy: {name: {_ilike: \$searchTerm}{gen}}, is_default: {_eq: true}, pokemon_v2_pokemontypes: {pokemon_v2_type: {name: {_in: \$types}}}}, order_by: {pokemon_species_id: asc}) {
      id
      pokemon_v2_pokemonspecy {
        pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 9}}) {
          pokemon_species_id
          name
        }
      }
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

  Future<List<PokemonListEntity>> getPokemons(BuildContext context, int limit, int offset, {String searchTerm = "", List<String> types = pokemonTypesList, String generation = ""}) async {
    types = types.isEmpty ? pokemonTypesList : types;
    if (generation != "") {
      generation = generationFilter(generation);
    }
    String finalQuery = getPokemonsQuery.replaceAll("{gen}", generation);
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(finalQuery),
      variables: {'limit': limit, 'offset': offset, 'searchTerm': '%$searchTerm%', 'types': types},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final pokemons = result.data!['pokemon_v2_pokemon'] as List;

    return pokemons.map((pokemon) => PokemonListEntity(
      id: pokemon['id'],
      pokedexNumber: pokemon['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames'][0]['pokemon_species_id'],
      name: pokemon['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames'][0]['name'],
      spriteUrl: pokemon['pokemon_v2_pokemonsprites'][0]['sprites'],
      type: (pokemon['pokemon_v2_pokemontypes'] as List).map((type) => type['pokemon_v2_type']['name']).toList(),
    )).toList();
  }

  String generationFilter(String generation) {
    if (generation == "") {
      return "";
    }
    int gen = genNameToId[generation]!;
    return ", generation_id: {_eq: $gen}";
  }
}