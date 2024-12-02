# Pokedex app

## Descripción del Proyecto
Una **Pokedex** interactiva construida con **Flutter** que permite a los usuarios explorar información detallada sobre los Pokémon. La aplicación ofrece una interfaz atractiva y funcional donde los usuarios pueden buscar Pokémon por nombre, utilizando una variedad de filtro y cambiando el orden en que son mostrados, esta tambien permite ver detalles diferentes detalles sobre estos como: estadísticas, movimientos, habilidades y evoluciones. 

Esta aplicación consume datos de desde la PokeAPI  externa utilizando **GraphQL** y proporciona una experiencia fluida con una interfaz visualmente enriquecida, incluyendo el uso de iconos SVG para representar los tipos de Pokémon.


## Funcionalidades Principales
- Pantalla de lista de Pokémon: una vista de desplazamiento con imágenes y nombres de Pokémon, con la opcion de mover Pokémons a una lista de favoritos.
- Pantalla de detalles del Pokémon: muestra información detallada, incluidas descripción, tipo, peso y altura.
    - Estadísticas de combate: desglose de los valores de base, maximos y minimo para todas las estadisticas del Pokémon.
    - Arbol evolutivo: visualización grafica del arbol evolutivo del Pokémon.
    - Listado de movimientos: listado de todos los movimientos a los que puede acceder el Pokémon.
- Búsqueda Avanzada: habilidad encontrar rápidamente Pokémon específicos utilizando la función de búsqueda por nombre, filtros por tipo, habilidades y generacion en la que fue introducido.


## Tecnologías Utilizadas
### Tecnologías
- Flutter
- PokeAPI
- GraphQL
### Librerias
- graphql_flutter
- flutter_svg
- graphview

## Configuración e Instalación

Clonar el repositorio:

```shell
git clone https://github.com/JosueGG04/pokedex_app.git
cd pokedex
```

Instalar dependencias de Flutter:

```shell
flutter pub get
```

Ejecutar la aplicación:

```shell
flutter run
```

## Uso de la API GraphQL

La aplicación emplea múltiples consultas GraphQL para interactuar de forma eficiente con la PokéAPI y recuperar información detallada sobre los Pokémon. En particular, se realizan consultas específicas para:

- Lista de Pokémons: se cargan datos basicos para  visualizarlos en la lista: nombre, tipos, ID y sprites. Tambien existe una llamada para cargar todas habilidades para posteriormente permitir al usuario filtrar por las mismas. 
- Detalles (about): se cargan datos mas especificos del Pokémon seleccionado, tales como, su descripción de Pokedex, titulo descriptivo (por ejemplo, bulbasaur: Pokémon semilla), altura y tamaño, ademas de el listado de habilidades que puede poseer el Pokémon seleccionado.
- Movimientos: se carga el listado de movimientos del Pokémon en conjunto con informacion relevante para reconocer su funcionalidad en batalla, poder, presición y puntos de poder.
- Evoluciones: se carga el arbol evolutivo del Pokémon para procesarlo y mostrar una visualización de este.
- Estadisticas base: se cargan las 6 estadisticas base del Pokémon para por medio de calculos poder mostrarlas en conjunto con las estadisticas maximas y minimas al nivel 100.

Aqui se encuentra el query utilizado para conseguir la información mostrada en la seccion de Info de la pantalla de detalles del Pokémon:
```GraphQL
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
```
## Decisiones de Diseño 

## Componentes de Flutter: