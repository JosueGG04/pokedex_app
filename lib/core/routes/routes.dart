import 'package:flutter/material.dart';
import 'package:pokedex_app/src/views/home.dart';

final Map<String, Widget Function(BuildContext)> routes  = {
  '/': (context) => const Home(),
};