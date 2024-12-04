import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_app/core/entities/pokemon_evolution_entity.dart';
import 'package:pokedex_app/core/entities/pokemon_list_entity.dart';
import '../entities/pokemon_abilities_entity.dart';
import '../entities/pokemon_info_entity.dart';
import '../entities/pokemon_moves_entity.dart';
import '../entities/pokemon_stats_entity.dart';

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
      fetchPolicy: FetchPolicy.noCache
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final pokemon = result.data!['pokemon_v2_pokemon_by_pk'];

    return PokemonInfoEntity(
      id: id,
      name: pokemon['name'],
      genus: pokemon['pokemon_v2_pokemonspecy']
          ['pokemon_v2_pokemonspeciesnames'][0]['genus'],
      description: pokemon['pokemon_v2_pokemonspecy']
          ['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text'],
      height: pokemon['height'].toDouble(),
      weight: pokemon['weight'].toDouble(),
      abilities: pokemon['pokemon_v2_pokemonabilities']
          .map<Ability>((ability) => Ability(
              name: ability['pokemon_v2_ability']['pokemon_v2_abilitynames'][0]
                      ['name']
                  .toString(),
              description: ability['pokemon_v2_ability']
                      ['pokemon_v2_abilityflavortexts'][0]['flavor_text']
                  .toString()))
          .toList(),
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

  Future<PokemonStatsEntity> getPokemonStats(
      BuildContext context, int id) async {
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(getPokemonStatsQuery),
      variables: {'id': id},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final pokemon = result.data!['pokemon_v2_pokemon'][0];
    final stats = pokemon['pokemon_v2_pokemonstats'];

    return PokemonStatsEntity(
      hp: stats.firstWhere(
          (stat) => stat['pokemon_v2_stat']['name'] == 'hp')['base_stat'],
      attack: stats.firstWhere(
          (stat) => stat['pokemon_v2_stat']['name'] == 'attack')['base_stat'],
      defense: stats.firstWhere(
          (stat) => stat['pokemon_v2_stat']['name'] == 'defense')['base_stat'],
      specialAttack: stats.firstWhere((stat) =>
          stat['pokemon_v2_stat']['name'] == 'special-attack')['base_stat'],
      specialDefense: stats.firstWhere((stat) =>
          stat['pokemon_v2_stat']['name'] == 'special-defense')['base_stat'],
      speed: stats.firstWhere(
          (stat) => stat['pokemon_v2_stat']['name'] == 'speed')['base_stat'],
    );
  }

  String getPokemonMovesQuery = """
  query getPokemonMoves(\$id: Int!) {
    pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
      name
      pokemon_v2_pokemonmoves(distinct_on: move_id) {
        move_id
        level
        pokemon_v2_move {
          name
          power
          accuracy
          pp
          pokemon_v2_type {
            name
          }
          pokemon_v2_movedamageclass {
            name
          }
        }
        pokemon_v2_movelearnmethod {
          name
          id
        }
      }
    }
  }
  """;

  Future<List<PokemonMovesEntity>> getPokemonMoves(
      BuildContext context, int id) async {
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(getPokemonMovesQuery),
      variables: {'id': id},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final pokemon = result.data!['pokemon_v2_pokemon'][0];
    final moves = pokemon['pokemon_v2_pokemonmoves'];

    return moves
        .map<PokemonMovesEntity>((move) => PokemonMovesEntity(
              name: move['pokemon_v2_move']['name'],
              accuracy: move['pokemon_v2_move']['accuracy']?.toDouble(),
              pp: move['pokemon_v2_move']['pp'],
              power: move['pokemon_v2_move']['power'],
              level: move['level'],
              type: move['pokemon_v2_move']['pokemon_v2_type']['name'],
              damageClass: move['pokemon_v2_move']['pokemon_v2_movedamageclass']['name'],
              learningMethod: move['pokemon_v2_movelearnmethod']['name'],
              learningMethodId: move['pokemon_v2_movelearnmethod']['id'],
            ))
        .toList();
  }

  String getPokemonEvolutionQuery = """
  query getEvolutionChain(\$id: Int = 1) {
    pokemon_v2_pokemon_by_pk(id: \$id) {
      id
      name
      pokemon_v2_pokemonspecy {
        pokemon_v2_evolutionchain {
          id
          pokemon_v2_pokemonspecies {
            evolves_from_species_id
            id
            name
            pokemon_v2_pokemons(where: {is_default: {_eq: true}}) {
              id
              pokemon_v2_pokemonsprites {
                sprites(path: "other.home.front_default")
              }
              pokemon_v2_pokemontypes {
                pokemon_v2_type {
                  name
                }
              }
              pokemon_v2_pokemonspecy {
                pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 9}}) {
                  pokemon_species_id
                }
              }
            }
          }
        }
      }
    }
  }
  """;

  Future<List<PokemonEvolutionEntity>> getPokemonEvolution(
      BuildContext context, int id) async {
    final client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(getPokemonEvolutionQuery),
      variables: {'id': id},
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final pokemon = result.data!['pokemon_v2_pokemon_by_pk'];
    final evolutionChain = pokemon['pokemon_v2_pokemonspecy']
        ['pokemon_v2_evolutionchain']['pokemon_v2_pokemonspecies'];
    
    return evolutionChain
        .map<PokemonEvolutionEntity>((evolution) => PokemonEvolutionEntity(
              id: evolution['id'],
              evolvesFromId: evolution['evolves_from_species_id'],
              pokemonListTile: PokemonListEntity(
                id: evolution['pokemon_v2_pokemons'][0]['id'],
                pokedexNumber: evolution['pokemon_v2_pokemons'][0]['pokemon_v2_pokemonspecy']
                    ['pokemon_v2_pokemonspeciesnames'][0]['pokemon_species_id'],
                name: evolution['name'],
                spriteUrl: evolution['pokemon_v2_pokemons'][0]
                    ['pokemon_v2_pokemonsprites'][0]['sprites'],
                type: (evolution['pokemon_v2_pokemons'][0]['pokemon_v2_pokemontypes']
                        as List)
                    .map<String>((type) => type['pokemon_v2_type']['name'])
                    .toList(),
              ),
            ))
        .toList();
  }
}
