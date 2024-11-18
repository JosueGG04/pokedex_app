import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/utils/full_filters.dart';
import 'package:pokedex_app/core/utils/type_colors.dart';

class FiltersModal extends StatefulWidget {
  FiltersModal({super.key, required this.typeFilters, required this.refreshList});
  final List<Tab> tabs = [
    const Tab(text: 'Types'),
    const Tab(text: 'Generation'),
  ];
  final List<String> typeFilters;
  final Function() refreshList;
  

  @override
  _FiltersModalState createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          FilterModalTopBar(),
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
                TypeFilter(typeFilters: widget.typeFilters, refreshList: widget.refreshList),
                Container(
                  color: Colors.blue,
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
    return Container(
      child: Wrap(
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
            );
          }).toList(),
        ],
      ),
    );
  }
}

//generation filter