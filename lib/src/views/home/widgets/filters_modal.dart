import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/repositories/pokemon_list_repository.dart';
import 'package:pokedex_app/core/utils/filter_utils.dart';
import 'package:pokedex_app/core/utils/type_colors.dart';

class FiltersModal extends StatefulWidget {
  FiltersModal({super.key, required this.typeFilters, required this.refreshList, required this.selectedGen, required this.onGenSelected, required this.selectedAbility, required this.onAbilitySelected, required this.repository});
  final List<Tab> tabs = [
    const Tab(text: 'Types'),
    const Tab(text: 'Generation'),
    const Tab(text: 'Abilities'),
  ];
  final List<String> typeFilters;
  final String selectedGen;
  final String selectedAbility;
  final Function() refreshList;
  final Function(String) onGenSelected;
  final Function(String) onAbilitySelected;
  final PokemonListRepository repository;
  

  @override
  _FiltersModalState createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _selectedGen;
  late String _selectedAbility;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _selectedAbility = widget.selectedAbility;
    _selectedGen = widget.selectedGen;
  }

  @override
  dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const FilterModalTopBar(),
          TabBar(
            controller: _tabController,
            tabs: widget.tabs,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TypeFilter(
                  typeFilters: widget.typeFilters, 
                  refreshList: widget.refreshList
                ),
                GenerationFilter(
                  selectedGen: _selectedGen, 
                  onGenSelected: (gen) {
                    setState(() {
                      _selectedGen = gen;
                    });
                    widget.onGenSelected(gen);
                    widget.refreshList();
                  },
                  refreshList: widget.refreshList, 
                ),
                AbilityFilter(
                  selectedAbility: _selectedAbility, 
                  onAbilitySelected: (ability) {
                    setState(() {
                      _selectedAbility = ability;
                    });
                    widget.onAbilitySelected(ability);
                    widget.refreshList();
                  },
                  refreshList: widget.refreshList, 
                  repository: widget.repository, 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterModalTopBar extends StatelessWidget {
  const FilterModalTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

//type filter
class TypeFilter extends StatefulWidget {
  TypeFilter({super.key, required this.typeFilters, required this.refreshList});
  final List<String> typeFilters;
  final Function() refreshList;
  
  @override
  _TypeFilterState createState() => _TypeFilterState();
}

class _TypeFilterState extends State<TypeFilter> {
  late List<String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = widget.typeFilters;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton(
            onPressed: _selectedFilters.isEmpty ? null : () {
              setState(() {
                _selectedFilters.clear();
              }); 
              widget.refreshList();
            },
            child: Text("Clear", style: TextStyle(color: _selectedFilters.isEmpty ? Colors.grey : Colors.blue)),
          ),
          Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              ...pokemonTypesList.map((type) {
                return FilterChip(
                  label: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/$type.svg',
                            width: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(type, style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  selected: _selectedFilters.contains(type),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add(type);
                      } else {
                        _selectedFilters.remove(type);
                      }
                    });
                    widget.refreshList();
                  },
                  backgroundColor: typeColors[type]!,
                  selectedColor: typeColors[type]!.withOpacity(0.5),
                  showCheckmark: false,
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}

//generation filter
class GenerationFilter extends StatefulWidget {
  GenerationFilter({super.key, required this.selectedGen, required this.refreshList, required this.onGenSelected});
  final String selectedGen;
  final Function(String) onGenSelected;
  final Function() refreshList;
  
  @override
  _GenerationFilterState createState() => _GenerationFilterState();
}

class _GenerationFilterState extends State<GenerationFilter> {
  late String _selectedGen;

  @override
  void initState() {
    super.initState();
    _selectedGen = widget.selectedGen;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton(
            onPressed: _selectedGen.isEmpty ? null : () {
              setState(() {
                _selectedGen = "";
              }); 
              widget.onGenSelected("");
            }, 
            child: Text("Clear", style: TextStyle(color: _selectedGen.isEmpty ? Colors.grey : Colors.blue)),
          ),
          Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              ...pokemonGenerationsList.map((gen) {
                return FilterChip(
                  label: Text(gen, style: const TextStyle(color: Colors.white)),
                  selected: _selectedGen == gen,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedGen = gen;
                    });
                    widget.onGenSelected(gen);
                  },
                  backgroundColor: Colors.grey,
                  selectedColor: Colors.grey.withOpacity(0.5),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

//ability filter
class AbilityFilter extends StatefulWidget {
  AbilityFilter({super.key, required this.selectedAbility, required this.refreshList, required this.repository, required this.onAbilitySelected});
  late final String selectedAbility;
  final Function() refreshList;
  final Function(String) onAbilitySelected;
  final PokemonListRepository repository;
  
  @override
  _AbilityFilterState createState() => _AbilityFilterState();
}

class _AbilityFilterState extends State<AbilityFilter> {
  late String _selectedAbility;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  int limit = 50;
  int offset = 0;
  bool _isLoadingMore = false;
  bool _isFirstLoad = true; 
  final List<String> pokemonAbilitiesList = [];
  final controller = ScrollController();
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset && !_isLoadingMore) {
        _fetchAbilities();
      }
    });
    _selectedAbility = widget.selectedAbility;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _fetchAbilities();
    }
  }

  Future<void> _fetchAbilities() async {
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final newAbilities = await widget.repository.getPokemonAbilities(context, limit: limit, offset: offset, searchTerm: _searchTerm);
      setState(() {
        pokemonAbilitiesList.addAll(newAbilities);
        offset += limit;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _clearList() {
    setState(() {
      pokemonAbilitiesList.clear();
      offset = 0;
    });
  }

  void _refreshList() {
    setState(() {
      _clearList();
      _fetchAbilities();
    });
  }

  void _onSearchChanged() {
    const duration = Duration(milliseconds: 300);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        setState(() {
          _searchTerm = _searchController.text;
        });
        _refreshList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Ability',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: _selectedAbility.isEmpty ? null : () {
              setState(() {
                _selectedAbility = "";
              });
              widget.onAbilitySelected("");
            }, 
            child: Text("Clear", style: TextStyle(color: _selectedAbility.isEmpty ? Colors.grey : Colors.blue)),
          ),
          Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              ...pokemonAbilitiesList.map((ability) {
                return FilterChip(
                  label: Text(ability, style: const TextStyle(color: Colors.white)),
                  selected: _selectedAbility == ability,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedAbility = ability;
                    });
                    widget.onAbilitySelected(ability);
                  },
                  backgroundColor: Colors.grey,
                  selectedColor: Colors.grey.withOpacity(0.5),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}