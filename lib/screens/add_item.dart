import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/grocery_item.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int quantitiy = 1;
  Category category = categories[Categories.fruit]!;

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(),
          name: name,
          quantity: quantitiy,
          category: category,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onSaved: (newValue) => name = newValue!,
                  maxLength: 50,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      label: Text('Name'), hintText: 'John Doe'),
                  validator: (value) {
                    if (value == null || value.trim().length <= 1) {
                      return 'name not accebtable';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onSaved: (newValue) => quantitiy = int.parse(newValue!),
                        initialValue: '1',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        validator: (value) {
                          if (int.parse(value!) <= 0) {
                            return 'Quantitiy must be greater than 1';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: category,
                          items: categories.entries
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        color: e.value.color,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(e.value.title),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => category = value!),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: onSubmit,
                      child: const Text('Submit'),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
