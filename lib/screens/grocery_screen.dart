import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  @override
  Widget build(BuildContext context) {
    Widget activeContent;
    activeContent = ListView.builder(
      itemCount: groceryItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            height: 16,
            width: 16,
            color: groceryItems[index].category.color,
          ),
          title: Text(groceryItems[index].name),
          trailing: Text(groceryItems[index].quantity.toString()),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery LIst'),
      ),
      body: activeContent,
    );
  }
}
