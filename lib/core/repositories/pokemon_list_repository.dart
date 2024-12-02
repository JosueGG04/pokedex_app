import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import 'package:pokedex_app/core/utils/LocalStorage.dart';
import 'package:pokedex_app/core/utils/filter_utils.dart';

import '../utils/order_utils.dart';

class PokemonListRepository {

  String getPokemonsQuery = """
  query getPokemons(\$limit: Int = 20, \$offset: Int = 0, \$searchTerm: String = "%%", \$types: [String] = "\$") {
    pokemon_v2_pokemon(offset: \$offset, limit: \$limit, where: {pokemon_v2_pokemonspecy: {name: {_ilike: \$searchTerm}{gen}}, is_default: {_eq: true}, pokemon_v2_pokemontypes: {pokemon_v2_type: {name: {_in: \$types}}}{favorites}{ability}}, order_by: {pokemon_species_id: asc}) {
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

  Future<List<PokemonListEntity>> getPokemons(BuildContext context, int limit, int offset, {String searchTerm = "", List<String> types = pokemonTypesList, String generation = "", String ability = "", bool favorites = false, orderBy = "", order = "asc"}) async {
    types = types.isEmpty ? pokemonTypesList : types;
    String finalQuery = getPokemonsQuery.replaceAll("{gen}", generationFilter(generation));
    if (orderBy != "") {
      finalQuery = finalQuery.replaceAll(", order_by: {pokemon_species_id: asc}", orderByQuery(orderBy, order));
    }
    finalQuery = finalQuery.replaceAll("{ability}", abilityFilter(ability));
    finalQuery = finalQuery.replaceAll("{favorites}", favoritesFilter(LocalStorage.getFavorites(), isFavoriteList: favorites));
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

  String orderByQuery(String orderBy, String order) {
    String query = "";
    if (orderBy == "ID" || orderBy == "Name") {
      query = queryOrder[orderBy]!;
      return ", order_by: {$query : $order}";
    } else if (orderBy == "Ability" || orderBy == "Type") {
      query = queryOrder[orderBy]!;
      return ", order_by: {$query: $order}}}";
    }
    return "";
  }

  String generationFilter(String generation) {
    if (generation == "") {
      return "";
    }
    int gen = genNameToId[generation]!;
    return ", generation_id: {_eq: $gen}";
  }


  String abilityFilter(String ability) {
    if (ability == "") {
      return "";
    }
    return ", pokemon_v2_pokemonabilities: {pokemon_v2_ability: {name: {_eq: \"$ability\"}}}";
  }

  String favoritesFilter(List<int> favorites, {bool isFavoriteList = false}) {
    if (!isFavoriteList) {
      return "";
    }
    return ", id: {_in: ${favorites.toString()}}";
  }

  //String ability list query
  String getPokemonAbilitiesQuery = """
  query getPokemonAbilities(\$searchTerm: String = "%%", \$limit: Int = 50, \$offset: Int = 10) {
    pokemon_v2_pokemonability(distinct_on: ability_id, order_by: {ability_id: asc, pokemon_v2_ability: {}}, where: {pokemon_v2_ability: {name: {_like: \$searchTerm}}}, offset: \$offset, limit: \$limit) {
      pokemon_v2_ability {
        name
      }
    }
  }
  """;

  Future<List<String>> getPokemonAbilities(BuildContext context, {String searchTerm = "", int limit = 50, int offset = 0}) async {
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(getPokemonAbilitiesQuery),
      variables: {'searchTerm': '%$searchTerm%', 'limit': limit, 'offset': offset},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final abilities = result.data!['pokemon_v2_pokemonability'] as List;

    return abilities.map<String>((ability) => ability['pokemon_v2_ability']['name']).toList();
  }
}