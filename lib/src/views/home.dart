import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('PokeDex'),
      ),
      body: const Center(
        child: Text('Welcome to PokeDex'),
      ),
    ));
  }
}
