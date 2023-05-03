import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/screens/add_item.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:http/http.dart' as http;

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<GroceryItem> _groceryItems = [];
  bool _isRecieving = false;
  String error = '';
  void _fetchItems() async {
    setState(() {
      _isRecieving = true;
    });
    final url = Uri.https('shopping-list-7b8bc-default-rtdb.firebaseio.com',
        'Shopping-List.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        error = "Unable to featch data, Please try again";
      });
    }
    final Map<String, dynamic> content = json.decode(response.body);
    List<GroceryItem> tempList = [];

    for (var item in content.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      tempList.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _isRecieving = false;
      _groceryItems = tempList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
              onPressed: () async {
                final GroceryItem newItem =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddItem(),
                ));
                setState(() {
                  _groceryItems.add(newItem);
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: error.isNotEmpty
          ? Center(
              child: Text(error),
            )
          : _isRecieving
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _groceryItems.length,
                  itemBuilder: (context, index) {
                    final item = _groceryItems[index];
                    return Dismissible(
                      onDismissed: (direction) async {
                        setState(() {
                          _groceryItems.remove(item);
                        });
                        final url = Uri.https(
                            'shopping-list-7b8bc-default-rtdb.firebaseio.com',
                            'Shopping-List/${item.id}.json');
                        final response = await http.delete(url);
                        if (response.statusCode >= 400) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed To delete'),
                            ),
                          );
                          setState(() {
                            _groceryItems.add(item);
                          });
                        }
                      },
                      background: Container(
                        color: Colors.red,
                      ),
                      key: ValueKey(item.id),
                      child: ListTile(
                        key: Key(_groceryItems[index].id),
                        leading: Container(
                          height: 20,
                          width: 20,
                          color: item.category.color,
                        ),
                        title: Text(item.name),
                        trailing: Text(item.quantity.toString()),
                      ),
                    );
                  }),
    );
  }
}
