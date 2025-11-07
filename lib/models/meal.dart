class Meal {
  final String id;
  final String name;
  final List<String> ingredients;
  final MealType type;
  final DateTime date;

  Meal({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'type': type.toString(),
      'date': date.toIso8601String(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      type: json['type'] == 'MealType.lunch' ? MealType.lunch : MealType.dinner,
      date: DateTime.parse(json['date']),
    );
  }
}

enum MealType {
  lunch,
  dinner,
}
