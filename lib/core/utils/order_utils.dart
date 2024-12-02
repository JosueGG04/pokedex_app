const List<String> pokemonOrderList = [
  'ID',
  'Name',
  'Ability',
  'Type',
];

const Map<String,String> queryOrder = {
  'ID': 'pokemon_species_id',
  'Name': 'name',
  'Ability': 'pokemon_v2_pokemonabilities_aggregate: {min: {ability_id',
  'Type': 'pokemon_v2_pokemontypes_aggregate: {min: {type_id',
};

const List<String> pokemonOrderDirectionList = [
  'asc',
  'desc',
];