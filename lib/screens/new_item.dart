import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  int _quantity = 1;
  var _category = categories[Categories.vegetables]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https(
          'shopping-list-arslan-default-rtdb.asia-southeast1.firebasedatabase.app',
          'Shopping-List.json');
      final response = await http.post(url,
          body: jsonEncode({
            'name': _name,
            'quantity': _quantity,
            'category': _category.category,
          }));

      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(),
          name: _name,
          quantity: _quantity,
          category: _category,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
                hintText: 'Milk',
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 2 ||
                    value.trim().length >= 50) {
                  return 'Please Enter the valid name.';
                }
                return null;
              },
              onSaved: (newValue) {
                _name = newValue!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _quantity.toString(),
                    decoration: const InputDecoration(
                      label: Text('Quantity'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length >= 200) {
                        return 'Please enter the valid Quantity';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _quantity = int.parse(newValue!);
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(
                      value: _category,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(category.value.category),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(
                          () {
                            _category = value!;
                          },
                        );
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('Save Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
