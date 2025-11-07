class ShoppingItem {
  final String id;
  final String name;
  bool isCompleted;
  final DateTime? dateAdded;
  final String? mealId;

  ShoppingItem({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.dateAdded,
    this.mealId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
      'dateAdded': dateAdded?.toIso8601String(),
      'mealId': mealId,
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      isCompleted: json['isCompleted'] ?? false,
      dateAdded:
          json['dateAdded'] != null ? DateTime.parse(json['dateAdded']) : null,
      mealId: json['mealId'],
    );
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    bool? isCompleted,
    DateTime? dateAdded,
    String? mealId,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      dateAdded: dateAdded ?? this.dateAdded,
      mealId: mealId ?? this.mealId,
    );
  }

  void toggleComplete() {
    isCompleted = !isCompleted;
  }
}
