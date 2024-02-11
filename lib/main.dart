import 'package:flutter/material.dart';
import 'package:shopping_list/screens/grocery_screen.dart';
import 'package:shopping_list/screens/new_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          surface: const Color.fromARGB(255, 42, 51, 59),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
        // brightness: Brightness.dark,
      ),
      home: const GroceryScreen(),
    );
  }
}
