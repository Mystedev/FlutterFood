import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/meal.dart';

class MealService extends ChangeNotifier {
  final String _mealsKey = 'meals';
  List<Meal> _meals = [];
  final Uuid _uuid = const Uuid();

  List<Meal> get meals => List.unmodifiable(_meals);

  Future<void> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mealsString = prefs.getString(_mealsKey);

    if (mealsString != null) {
      final List<dynamic> decoded = jsonDecode(mealsString);
      _meals = decoded.map((meal) => Meal.fromJson(meal)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(_meals.map((meal) => meal.toJson()).toList());
    await prefs.setString(_mealsKey, encodedData);
    notifyListeners();
  }

  Future<void> addMeal(Meal meal) async {
    _meals.add(meal);
    await _saveMeals();
  }

  Future<void> updateMeal(Meal updatedMeal) async {
    final index = _meals.indexWhere((meal) => meal.id == updatedMeal.id);
    if (index != -1) {
      _meals[index] = updatedMeal;
      await _saveMeals();
    }
  }

  Future<void> deleteMeal(String id) async {
    _meals.removeWhere((meal) => meal.id == id);
    await _saveMeals();
  }

  List<Meal> getMealsForDate(DateTime date) {
    return _meals
        .where((meal) =>
            meal.date.year == date.year &&
            meal.date.month == date.month &&
            meal.date.day == date.day)
        .toList();
  }

  List<Meal> getMealsForWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _meals
        .where((meal) =>
            meal.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            meal.date.isBefore(endOfWeek.add(const Duration(days: 1))))
        .toList();
  }

  String generateId() => _uuid.v4();
}

// Extension to handle JSON encoding/decoding
extension JsonExtension on Object {
  String toJsonString() => jsonEncode(this);
}

// Extension to handle JSON parsing
extension StringExtension on String {
  dynamic fromJsonString() => jsonDecode(this);
}
