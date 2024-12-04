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
- sharedPreferences
- cross_file
- flutter_debouncer
- Google fonts
- screenshot
- share plus
- pathprovider

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
La aplicación está conformada por diferentes pantallas, cada una diseñada una experiencia de usuario gratificante. A continuación se explican todas las pantallas y los componentes utilizados en estas:

### 1. Lista de Pokémon
Muestra una lista interactiva y desplazable de Pokémon, incluyendo sus imágenes, nombres, número de pokedex y sus tipos, que permite al usuario explorar y elegir un Pokémon para consultar información más detallada, tambien permite agregar un Pokémon a la lista de favoritos a la cual se puede acceder desde el panel de navegación inferior.

**Componetes:**
- `Scafold`: Estructura básica de la pantalla.
- `Column`: Organiza los elementos principales verticalmente.
- `Row`: Organiza los elementos superiores horizontalmente.
- `IconButton`: botones que acceden a los filtros y
- `FiltersModal`: widget personalizado que permite que el usuario seleccione entre filtros de tipo, generacion y habilidades.
- `OrderModal` (placeholder name): WIP
- `TextField`: campo de input de texto que permite la busqueda de Pokémons por nombre. 
- `List.Builder`: Crea una lista desplazable que muestra los Pokémon en un `PokemonListTile`.
- `PokemonListTile`: widget personalizado que dados los datos básicos de un Pokémon crea un elemento el cual al ser presionado envia a la pagina de informacion del Pokémon. Este elemento tambien posee un boton (con forma de estrella) que permite agregar el Pokémon a la lista de favoritos.
- `BottomNavigationBar`: widget que permite intercambiar entre widgets en un arreglo de widgets encontrado en el `body` del `Scafold` (en este caso entre la lista principal y la lista de favoritos)

## 2. Información Detallada de un Pokémon

Cuando el usuario selecciona un Pokémon de la lista principal, se despliega una pantalla detallada con información relevante. Esta pantalla muestra desde los datos básicos hasta habilidades y estadísticas visualmente atractivas.

### **Componentes:**

- **`PokemonInfoTab`**: Widget principal que construye la página de detalles del Pokémon seleccionado.
- **`Container`**: Define el fondo blanco y el estilo general del contenido.
- **`Column`**: Organiza los elementos en bloques principales:
  - Descripción del Pokémon.
  - Altura y peso.
  - Tipos y habilidades.
- **`Row`**: Presenta ítems como altura y peso en una disposición horizontal.
- **`SvgPicture`**: Muestra íconos SVG asociados a los tipos del Pokémon.
- **`Text`**: Estiliza los textos de cada sección como títulos, descripciones y detalles específicos.
- **`Stack`** y **`Positioned`**: Para superponer elementos como etiquetas estilizadas ("Species", "Abilities").
- **`MediaQuery`**: Se utiliza para calcular el ancho disponible de la pantalla, adaptándose a diferentes tamaños de dispositivos.
- **`PokemonStatsTab`**: Widget personalizado que muestra las estadísticas de combate del Pokémon en un formato visual interactivo:
  - **`TabBar`** y **`TabBarView`**: Organizan las estadísticas en tres pestañas:
    - **Base Stats**: Valores base de cada atributo.
    - **Min Stats**: Valores mínimos posibles para cada atributo.
    - **Max Stats**: Valores máximos posibles para cada atributo.
  - **`StatsGraph`**: Componente gráfico que presenta las estadísticas de forma visual mediante barras o gráficos de radar, adaptados al color del tipo principal del Pokémon.
  - **`TabController`**: Controlador que permite alternar entre las pestañas.
  - **`Positioned`**: Añade un título estilizado que identifica la sección como "Base Stats".
- **`PokemonMoves`**: Widget personalizado que muestra los movimientos del Pokémon.
  - Utiliza un **`Table`** para organizar los movimientos en columnas con información como:
  - **Nombre del movimiento** (con íconos SVG de tipo).
  - **Nivel** al que el Pokémon aprende el movimiento.
  - **Poder** (si aplica).
  - **Precisión** (si aplica).
  - **PP** (Puntos de Poder disponibles).
  - **`SvgPicture`** para íconos visuales de tipos asociados a los movimientos.
  - Cada fila del **`Table`** muestra un movimiento individual.
- **`PokemonEvolutions`**: Widget personalizado que muestra el árbol evolutivo del Pokémon.
  - Utiliza la libreria `graphview` para mostrar la visualizacion del árbol evolutivo conseguido.
  - Contiene la logica necesaria para armar el grafo apartir de la información conseguida de la llamada a la PokeAPI.
  - `EvolutionTile` widget personalizado que muestra nodos del árbol evolutivo y al ser presionado lleva al usuario a la vista de información del Pokémon selecionado.

## Créditos y Contribuciones
Desarrollado por Josué García y Brigibel Martinez.

Iconos de tipo: https://github.com/partywhale/pokemon-type-icons



PokeAPI: https://pokeapi.co/