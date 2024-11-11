import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../entities/pokemon_info_entity.dart';

class PokemonDetailsRepository {
  String getPokemonInfoQuery = """
  query pokemonInfo(\$id: Int = 1) {
  pokemon_v2_pokemon_by_pk(id: \$id) {
    name
    pokemon_species_id
    pokemon_v2_pokemonspecy {
      pokemon_v2_pokemonspeciesflavortexts(where: {language_id: {_eq: 9}, pokemon_v2_version: {}}, order_by: {pokemon_v2_version: {pokemon_v2_versiongroup: {}, version_group_id: desc}}, limit: 1) {
        flavor_text
      }
      pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 9}}) {
        genus
      }
    }
    weight
    height
    pokemon_v2_pokemonabilities(where: {pokemon_v2_ability: {is_main_series: {_eq: true}}}) {
      pokemon_v2_ability {
        pokemon_v2_abilitynames(where: {language_id: {_eq: 9}}) {
          name
        }
        pokemon_v2_abilityflavortexts(where: {pokemon_v2_language: {id: {_eq: 9}}}, order_by: {version_group_id: desc}, limit: 1) {
          flavor_text
        }
      }
    }
  }
}
  """;

  Future<PokemonInfoEntity> getPokemonInfo(BuildContext context, int id) async {
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(getPokemonInfoQuery),
      variables: {'id': id},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final pokemon = result.data!['pokemon_v2_pokemon_by_pk'];

    return PokemonInfoEntity(
      id: id,
      name: pokemon['name'],
      genus: pokemon['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames'][0]['genus'],
      description: pokemon['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text'],
      height: pokemon['height'].toDouble(),
      weight: pokemon['weight'].toDouble(),
      ability: pokemon['pokemon_v2_pokemonabilities'].map((ability) => ability['pokemon_v2_ability']['pokemon_v2_abilitynames'][0]['name']).toList(),
    );
  }

  String getPokemonStatsQuery = """
  query GetPokemonStats(\$id: Int) {
  pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
    name
    pokemon_species_id
    pokemon_v2_pokemonstats {
      base_stat
      pokemon_v2_stat {
        name
      }
    }
  }
}
  """;

  Future<List<Map<String, dynamic>>> getPokemonStats(BuildContext context, int id) async {
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(getPokemonStatsQuery),
      variables: {'id': id},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final pokemon = result.data!['pokemon_v2_pokemon'][0];

    return pokemon['pokemon_v2_pokemonstats'].map<Map<String, dynamic>>((stat) => {
      'name': stat['pokemon_v2_stat']['name'],
      'value': stat['base_stat'],
    }).toList();
  }
}