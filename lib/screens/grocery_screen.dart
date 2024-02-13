import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'dart:convert';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryItems = [];
  bool _loadingIndicator = true;

  void _loadData() async {
    final url = Uri.https(
        'shopping-list-arslan-default-rtdb.asia-southeast1.firebasedatabase.app',
        'Shopping-List.json');
    final response = await http.get(url);
    final Map<String, dynamic> loadItem = jsonDecode(response.body);
    final List<GroceryItem> newList = [];
    if (response.statusCode >= 400 || response.body == null) {
      return;
    }

    for (final item in loadItem.entries) {
      final category = categories.entries
          .firstWhere((itm) => itm.value.category == item.value['category'])
          .value;
      newList.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }
    setState(() {
      _groceryItems = newList;
      _loadingIndicator = false;
    });
  }

  void _newItem() async {
    final item = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) {
          return const NewItem();
        },
      ),
    );
    if (item == null) {
      return;
    }
    print(item);
    setState(() {
      _groceryItems.add(item);
    });
  }

  void _removeItem(GroceryItem item) {
    final indexofItem = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Row(
          children: [
            const Text('Item Removed. Undo'),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  _groceryItems.insert(indexofItem, item);
                });
              },
              icon: const Icon(
                Icons.undo,
                size: 20,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget activeContent;
    if (_loadingIndicator) {
      activeContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_groceryItems.isEmpty || _groceryItems == null) {
      activeContent = const Center(
        child: Text('No data found try adding one'),
      );
    } else {
      activeContent = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index]),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
            background: Container(
              height: 20,
              width: double.infinity,
              color: Colors.red,
            ),
            child: ListTile(
              leading: Container(
                height: 16,
                width: 16,
                color: _groceryItems[index].category.color,
              ),
              title: Text(_groceryItems[index].name),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery LIst'),
        actions: [
          IconButton(
            onPressed: _newItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: activeContent,
    );
  }
}
