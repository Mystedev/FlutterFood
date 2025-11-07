import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/shopping_item.dart';

class ShoppingService extends ChangeNotifier {
  final String _shoppingListKey = 'shopping_list';
  List<ShoppingItem> _items = [];
  final Uuid _uuid = const Uuid();

  List<ShoppingItem> get items => List.unmodifiable(_items);
  List<ShoppingItem> get activeItems =>
      _items.where((item) => !item.isCompleted).toList();
  List<ShoppingItem> get completedItems =>
      _items.where((item) => item.isCompleted).toList();

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString(_shoppingListKey);

    if (itemsString != null) {
      final List<dynamic> decoded = jsonDecode(itemsString);
      _items = decoded.map((item) => ShoppingItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString(_shoppingListKey, encodedData);
    notifyListeners();
  }

  Future<void> addItem(String name, {String? mealId}) async {
    final newItem = ShoppingItem(
      id: _uuid.v4(),
      name: name,
      dateAdded: DateTime.now(),
      mealId: mealId,
    );
    _items.add(newItem);
    await _saveItems();
  }

  Future<void> addItemsFromMeal(List<String> ingredients,
      {String? mealId}) async {
    for (var ingredient in ingredients) {
      await addItem(ingredient, mealId: mealId);
    }
  }

  Future<void> toggleItem(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        isCompleted: !_items[index].isCompleted,
      );
      await _saveItems();
    }
  }

  Future<void> updateItem(ShoppingItem updatedItem) async {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      await _saveItems();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _saveItems();
  }

  Future<void> clearCompleted() async {
    _items.removeWhere((item) => item.isCompleted);
    await _saveItems();
  }
}
