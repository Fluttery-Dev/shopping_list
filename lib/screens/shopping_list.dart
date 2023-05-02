import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/screens/add_item.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<GroceryItem> groceryItems = [
    GroceryItem(
        id: 'a',
        name: 'Milk',
        quantity: 1,
        category: categories[Categories.dairy]!),
    GroceryItem(
        id: 'b',
        name: 'Bananas',
        quantity: 5,
        category: categories[Categories.fruit]!),
    GroceryItem(
        id: 'c',
        name: 'Beef Steak',
        quantity: 1,
        category: categories[Categories.meat]!),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
              onPressed: () async {
                final newItem =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddItem(),
                ));

                if (newItem == null) {
                  return;
                }
                setState(() {
                  groceryItems.add(newItem);
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) {
            final item = groceryItems[index];
            return Dismissible(
              onDismissed: (direction) {
                setState(() {
                  groceryItems.remove(item);
                });
              },
              background: Container(
                color: Colors.red,
              ),
              key: ValueKey(item.id),
              child: ListTile(
                key: Key(groceryItems[index].id),
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
